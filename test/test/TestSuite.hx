import massive.munit.TestSuite;

import ExampleTest;
import rpg.EngineTest;
import rpg.image.ImageTest;
import rpg.map.TiledMapTest;
import rpg.ScriptTest;

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
		add(rpg.EngineTest);
		add(rpg.image.ImageTest);
		add(rpg.map.TiledMapTest);
		add(rpg.ScriptTest);
	}
}
