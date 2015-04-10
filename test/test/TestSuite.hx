import massive.munit.TestSuite;

import ExampleTest;
import rpg.EngineTest;
import rpg.map.TiledMapTest;
import rpg.ScriptTest;
import rpg.text.MessageTest;

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
		add(rpg.map.TiledMapTest);
		add(rpg.ScriptTest);
		add(rpg.text.MessageTest);
	}
}
