import org.apache.log4j.Logger;
import junit.framework.Assert;
import junit.framework.TestCase;

public class ExemploTest extends TestCase {
	private static Logger log = Logger.getRootLogger();

	public ExemploTest(String name)
	{
		super(name);
	}
	public void setUp()
	{
		log.info("getting ...");

	}
	public void testUnique()
	{
		log.info("checking for equality");
//		Assert.assertEquals(true, sone == stwo);
	}
}
