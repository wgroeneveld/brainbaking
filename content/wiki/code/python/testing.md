+++
title = "testing"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "python",
    "testing"
]
date = "2014-03-05"
+++
# Python Unit Testing 

## unittest module 

Spreekt voor zich:

```python
import unittest
from calculator import Calculator

class TestCalculator(unittest.TestCase):

	def setUp(self):
		self.calc = Calculator().calculate;

	def test_calculateBasicNumberReturnsNumber(self):
 		self.assertEqual(3, self.calc('3'))

	def test_calculateSimpleMultiplicationReturnsResult(self):
		self.assertEqual(10, self.calc('5*2'))

	def test_calculateInvalidStringShouldThrowException(self):
		self.assertRaises(ValueError, self.calc, ('blabl'))
```

Zie http://docs.python.org/3/library/unittest.html

  * `setUp` wordt automatisch aangeroepen. Beforeclass, aftereach etc etc bestaat ook.
  * alle methods met `test_` worden automatisch herkend. 

#### Hoe voer ik dit nu uit? 

Dit stuk onder uw py file plakken:

```python
if __name__ ###### '__main__':
	unittest.main()
```

En dan `python -m unittest -v calculatorTest`. de v flag geeft wat extra output, anders staat er gewoon OK. De test op zich builden in bijvoorbeeld sublime met de main method erin zorgt er ook voor dat deze automatisch uitgevoerd wordt. 

######= automatic test case discovery ######=

`python -m unittest discover` gaat alle unit testen vanaf huidig dir scannen en uitvoeren (instelbaar met params). Moet voldoen aan:

  1. extenden van `unittest.TestCase`
  2. voldoen aan python module structuur. Testen in files met prefix "test_x.py".
  3. Indien in subfolder "test": vergeet geen "__init__.py" file.

############= autotest ############=

Mogelijk met onder andere `autonose` (nose is een alternatief voor unittest) en `sniffer`. Om die te installeren moet je via de [pip package manager]({{< relref "wiki/code/python/packages.md" >}}) gaan, en dan gewoon sniffer uitvoeren in uw base directory.