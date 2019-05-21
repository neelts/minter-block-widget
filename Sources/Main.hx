package;

import kha.FramebufferOptions;
import haxe.Json;
import haxe.Http;
import kha.Color;
import kha.graphics2.Graphics;
import kha.Window;
import kha.input.Mouse;
import kha.WindowOptions;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

using DateTools;

class Main {

	static var w:Window;

	static var b = 0;
	static var t = 0;

	static function update():Void {
		try {
			var response:Response<MinterStatus> = Json.parse(Http.requestUrl('https://explorer-api.minter.network/api/v1/status'));
			if (response != null) {
				var status = response.data;
				if (status != null) {
					b = status.latestBlockHeight;
					t = status.averageBlockTime;
				}
			}
		}
	}

	static function render(g:Graphics):Void {
		g.begin();
		g.font = DefaultFont.get();
		g.color = Color.White;
		g.fontSize = 32;
		var t = Date.fromTime((138240 - b) * t * 1000);
		g.drawString('$b', 10, 10);
		g.drawString('${t.format("%dd %H:%M:%S")}', 10, 40);
		g.end();
	}

	public static function main() {
		var wo = new WindowOptions();
		wo.windowFeatures = FeatureOnTop | FeatureBorderless;
		var fo = new FramebufferOptions();
		fo.frequency = 10;
		System.start({title: "Project", width: 256, height: 128, window: wo, framebuffer: fo}, function (w) {
			Main.w = w;
			Assets.loadEverything(() -> {
				init();
				Scheduler.addTimeTask(() -> update(), 0, 10);
				System.notifyOnFrames((frames:Array<Framebuffer>) -> render(frames[0].g2));
			});
		});
	}

	static function init() {

		var m = Mouse.get();

		var sx = 0;
		var sy = 0;
		var wx = 0;
		var wy = 0;

		m.notify(
			(_, x, y) -> {
				wx = w.x;
				wy = w.y;
				sx = x;
				sy = y;
			}, 
			(b, x, y) -> {
				switch (b) {
					case 0: 
						w.x = wx + (x - sx);
						w.y = wy + (y - sy);
					case 1: System.stop();
					default:
				}
				return;
			}, null, null
		);
	}
}

typedef Response<Data> = {
	var data:Data;
}

typedef MinterStatus = {
	var averageBlockTime:Float;
	var bipPriceBtc:Float;
	var bipPriceChange:Float;
	var bipPriceUsd:Float;
	var latestBlockHeight:Int;
	var latestBlockTime:String;
	var marketCap:Float;
	var totalTransactions:Int;
	var transactionsPerSecond:Float;
}