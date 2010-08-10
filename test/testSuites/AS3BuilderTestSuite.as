package testSuites
{

import org.teotigraphix.as3builder.impl.TestAS3Factory;
import org.teotigraphix.as3builder.impl.TestAS3FactoryClass;
import org.teotigraphix.as3builder.impl.TestAS3FactoryInterface;
import org.teotigraphix.as3builder.impl.TestAS3FactoryMethod;

[Suite]
[RunWith("org.flexunit.runners.Suite")]

public class AS3BuilderTestSuite
{
	//public var testAS3Factory:TestAS3Factory;
	public var testAS3FactoryClass:TestAS3FactoryClass;
	public var testAS3FactoryInterface:TestAS3FactoryInterface;
	public var testAS3FactoryMethod:TestAS3FactoryMethod;
}
}