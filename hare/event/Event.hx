package hare.event;

/**
 * ...
 * @author Kevin
 */

class Event
{
	public var mapId:Int;
	public var eventId:Int;
	public var currentPage:EventPage;
	public var pages:Array<EventPage>;
	
	public function new (mapId, eventId, pageData:Array<EventPageData>)
	{
		this.mapId = mapId;
		this.eventId = eventId;
		
		pages = [for (pd in pageData) new EventPage(pd.conditions, pd.trigger, pd.script)];
		currentPage = pages[0];
	}
}

class EventPage
{
	public var trigger:EventTrigger;
	public var conditions:String;
	public var script:String;
	
	public function new(conditions, trigger, script)
	{
		this.conditions = conditions;
		this.trigger = switch (trigger) 
		{
			case "overlapaction": EOverlapAction;
			case "action": EAction;
			case "bump": EBump;
			case "overlap": EOverlap;
			case "nearby": ENearby;
			case "autorun": EAutorun;
			case "parallel": EParallel;
			default: EAction;
		}
		this.script = script;
	}
}

enum EventTrigger
{
	EOverlapAction;
	EAction;
	EBump;
	EOverlap;
	ENearby;
	EAutorun;
	EParallel;
}

typedef EventData = 
{
	id:Int,
	pages:Array<EventPageData>,
}

typedef EventPageData = 
{
	?conditions:String,
	trigger:String,
	script:String,
}