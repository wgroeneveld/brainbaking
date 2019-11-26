package be.kuleuven.ses.di.guice;

import be.kuleuven.ses.di.DBHandle;
import com.google.inject.AbstractModule;

public class GuiceConfigModule extends AbstractModule {

    @Override
    protected void configure() {
        bind(DBHandle.class).toInstance(new DBHandle("config url"));
    }
}
