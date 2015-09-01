import massive.munit.TestSuite;

import ExampleTest;
import hare.EngineTest;
import hare.image.ImageTest;
import hare.map.TiledMapTest;
import hare.ScriptTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(ExampleTest);
		add(hare.EngineTest);
		add(hare.image.ImageTest);
		add(hare.map.TiledMapTest);
		add(hare.ScriptTest);
	}
}
