---
title: Unit Testing Stored Procedures
bigimg: Unit Testing Stored Procedures.jpg
date: '2013-10-10'
aliases:
- /post/unit-testing-stored-procedures/
subtitle: And a pragmatic guide on how to include them into your build system. 
tags: [ 'unit testing', 'sql']
---

This article is based on the notes I've collected on [My Wiki](http://brainbaking.com/wiki/code/db/sql). 

Test Driven Development (or TDD), it's one of those buzz words which usuallly appear in the same sentence with "scrum" or "XP". But in practice, I've seen few people actually applying it all the way through. What do I mean by that? You're probably very familiar with, say Java or .NET, and you know how to write unit tests in that language using your beloved IDE. That's a good start, right. Maybe you might even do it the test-first way: writing a failing test (letting it fail for the right reason), writing the implementation and maybe some refactoring. Red, Green, Refactor. 

But what do you do when you need to step out of your language comfort zone to write some Javascript on the client side? Do you copypaste stuff or try to apply the same techniques as you're used to? You might have heard from test frameworks like [Jasmine](http://pivotal.github.io/jasmine/) and use these. Also good for you! Client side development is very popular, but what about SQL? Do you write tests for stored procedures? I thought so. There are plenty of frameworks available to help you in doing this, for instance [SQL Developer](http://docs.oracle.com/cd/E15846_01/doc.21/e15222/unit_testing.htm) which I used because it's already installed on every developer's PC and has a "friendly" interface. 

![sql dev unit test](http://brainbaking.com/wiki/_media/code/db/unittest_sqldev.png)

Once you create a "test repository", SQL Developer will create test tables to store it's unit test descriptions and results, prefixed by "UT_". You can specify whether you'd like to create a new scheme for it or not. When creating a new test, the tool asks you a couple of questions:

1. What do you want to insert or execute before the test? (Setup phase)
2. What stored procedure do you want to execute? (Execute system under test phase)
3. What should the result of the procedure be, or execute a query and check it's results? (Verify phase)
4. What do you want to insert or execute after the test? (Teardown phase)

You can reuse the parts to be executed in the different phases for another unit test, yay! This data will also be stored in the predefined tables. 

### But what about existing data when inserting new stuff?

use this as teardown:

    ROLLBACK;

### But how do you execute a stored procedure with IN/OUT REF CURSOR arguments?

SQL Developer has some trouble executing that, indeed. In this case, we use a little trick:

1. Create a dummy stored procedure:

		create or replace 
		PROCEDURE UT_DUMMY AS 
		BEGIN
		  NULL;
		END UT_DUMMY;

2. Execute the dummy procedure in the SUT phase.
3. Use the verify phase to call the actual to test procedure yourself, and do your verification stuff yourself:

		DECLARE     
		  P_USERID NUMBER;     
		  MY_P_CURSOR SCHEMA.PACKAGE.Cursor;     
		  cursor_element MY_P_CURSOR.SCHEMA.CursorType;     
		  found boolean;     
		BEGIN     
		  P_USERID := 11;     
		  found := false;     
			   
		  PACKAGE.MYPROCEDURE(     
			P_USERID => P_USERID,     
			P_CURSOR => MY_P_CURSOR     
		  );     
			 
		 WHILE TRUE LOOP     
			FETCH MY_P_CURSOR INTO cursor_element;     
			EXIT WHEN MY_P_CURSOR%NOTFOUND;     
			IF cursor_element.columntocheck = 'My value' THEN     
			  found  := true;     
			END IF;     
		  END LOOP;     
			 
		 IF found = false THEN     
		   raise_application_error(-20000, 'Your error message in here!');     
		 END IF;     
			 
		END; 

### Okay but what about integrating the exeuction of these tests in my build system?

You can use the commandline utility provided by SQL Developer to execute a test or a suite:

    ututil -run -suite -name [name] -repo [repo] -db [db] -log 3

It's very interesting to dynamically import and export tests using "-imp" and "-exp", and creating one suite using this PL/SQL:

	SET serveroutput ON;

	delete from ut_suite_items;
	delete from ut_suite;

	DROP SEQUENCE ut_suite_items_seq;
	CREATE SEQUENCE ut_suite_items_seq
	  MINVALUE 0
	  MAXVALUE 999999999999999999999999999
	  START WITH 0
	  INCREMENT BY 1;
	  
	DECLARE
		suiteid VARCHAR2(900) := 'ALL';
		utid VARCHAR2(900);
		cursor tableCursor is SELECT UT_ID FROM UT_TEST;
	BEGIN

	dbms_output.enable(10000);
	DBMS_OUTPUT.PUT_LINE('Creating one test suite to rule them ALL...');

	insert into ut_suite(ut_sid, coverage, name, created_on, created_by, updated_on, updated_by)
	  values(suiteid, 0, suiteid, null, null, null, null);

	open tableCursor;
	fetch tableCursor into utid;
	WHILE (tableCursor%FOUND) LOOP

	  insert into ut_suite_items(ut_sid, ut_id, ut_nsid, run_start, run_tear, sequence, created_on, created_by, updated_on, updated_by)
		values (suiteid, utid, null, 'Y', 'Y', ut_suite_items_seq.nextval, null, null, null, null);

	  fetch tableCursor into utid;
	END LOOP;
	close tableCursor;

	commit;
	DBMS_OUTPUT.PUT_LINE('SUCCESS - test suite created!');

	END;
	/

It creates only one suite called 'ALL' which can then be executed. The commandline utility will output "UT_SUCCESS" or throw some kind of exception if one of the tests failed. 

### I still get errors using ututil, some ConnectException?

the utility cannot handle any TNS connections you've entered in SQL Developer. Change these to regular connection strings and all will be well. Yes it's a huge disadvantage, and yes the connection settings are stored in your locally installed SQL Developer instance, which also kind of sucks. We needed to install SQL developer on the Build integration PC and configure the same connections within it. 

### What about versioning? The tests are stored in my DB, but it doesn't evolve as quickly as the code does!

Right, that's where the import/export thing comes in. We store the actual unit tests in XML format inside our regular source control system, next to the "other" unit tests (in this case in .NET). Every time someone writes a unit test using SQL developer, it extracts that test using:

    ututil -exp -test [name] -file [file] ...

which creates an XML file. Executing the tests happen within a wrapper .NET test class, which goes through some steps to setup the DB system correctly:

1. Cleanup all UT_TEST* and UT_SUITE* tables which would contain the acutal tests.
2. Loop through all XML files, and impor them one by one (they get inserted into the cleaned tables)
3. Generate the 'ALL' unit test suite - see PL/SQL above. 
4. Execute the test suite using ututil and parse the results from the command line.

That's as far as our imagination and budget goes. We have a stable system which is able to version the XML files - inserting the test data is still dependant on the actual state of the database. One could explore the dynamic creating of tables the stored procedures use, but as our codebase is legacy (read: really really old stuff), we decided not to invest too much time in that. 