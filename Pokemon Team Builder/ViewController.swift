//
//  ViewController.swift
//  Test4
//
//  Created by Hugh Broome on 7/4/18.
//  Copyright © 2018 Hugh Broome. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

class ResistSearchController: NSViewController {
	
	@IBOutlet weak var resistSearchString: NSTextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		Dex.initializeDex()
		Dex.defineTypeMatchups()
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	@IBAction func resistSearch(_ sender: Any) {
		resultsString.stringValue = ""
		let resistSearchArray = resistSearchString.stringValue.components(separatedBy: ", ")
		let resultsArray = Dex.findResistances(resistTypes: resistSearchArray)
		for result in resultsArray {
			resultsString.stringValue += "\(result) \n"
		}
	}
	@IBOutlet weak var resultsString: NSTextField!
	
}


class TeamBuilderController: NSViewController {
	
	@IBOutlet var searchResultsController: NSArrayController!
	
	@IBOutlet weak var searchTextField: NSTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		Dex.initializeDex()
//		Dex.defineTypeMatchups()
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	@IBAction func searchClicked(_ sender: AnyObject) {
		if (searchTextField.stringValue == "") {
			return
		}
		
		let dexSearchResults = Dex.searchDex(searchParam: searchTextField.stringValue)
//		let finalResults = convertPokemonToDict(dexSearchResults).map { return $0["species"] }
		let finalResults = convertPokemonToDict(dexSearchResults)
//			.map { return ($0["species"], $0["num"]) }
//			.map { return Result(dictionary: $0) }
		
//		self.searchResultsController.content = convertPokemonToString(Dex.searchDex(searchParam: searchTextField.stringValue))
		self.searchResultsController.content = finalResults
		
		print(self.searchResultsController.content!)
	}
	
	// Button to add members to Team

	
}

//
//extension TeamBuilderController {
//	func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
//		if commandSelector == #selector(insertNewline(_:)) {
//			searchClicked(searchTextField)
//		}
//		return false
//	}
//}

class TeamViewController: NSViewController {
	
	@IBOutlet var teamController: NSArrayController!
	
	//@IBOutlet var teamMembersController: NSArrayController!
	@IBOutlet weak var searchForTeam: NSTextField!
	@IBOutlet weak var arrayImage: NSImageView!
	@IBOutlet weak var tableView: NSTableView!
	
	@IBOutlet weak var baseHP: NSTextField!
	@IBOutlet weak var baseATK: NSTextField!
	@IBOutlet weak var baseDEF: NSTextField!
	@IBOutlet weak var baseSPA: NSTextField!
	@IBOutlet weak var baseSPD: NSTextField!
	@IBOutlet weak var baseSPE: NSTextField!
	
	@IBOutlet weak var hpLevel: NSLevelIndicator!
	@IBOutlet weak var atkLevel: NSLevelIndicator!
	@IBOutlet weak var defLevel: NSLevelIndicator!
	@IBOutlet weak var spaLevel: NSLevelIndicator!
	@IBOutlet weak var spdLevel: NSLevelIndicator!
	@IBOutlet weak var speLevel: NSLevelIndicator!
	
	@IBOutlet weak var hpSlider: NSSlider!
	@IBOutlet weak var atkSlider: NSSlider!
	@IBOutlet weak var defSlider: NSSlider!
	@IBOutlet weak var spaSlider: NSSlider!
	@IBOutlet weak var spdSlider: NSSlider!
	@IBOutlet weak var speSlider: NSSlider!
	
	@IBOutlet weak var hpSliderCell: NSSliderCell!
	//remains to be done with programming the rest of the sliders
	//on the backend, everything works, but not sure how to have sliders
	//re-draw if the desired set value for EVs is not possible in context
	

	@IBOutlet weak var monWeaknesses: NSTextField!
	@IBOutlet weak var monResistances: NSTextField!
	@IBOutlet weak var monImmunities: NSTextField!
	
	@IBOutlet weak var itemSelectButton: NSPopUpButton!
	
	@IBOutlet weak var move1Select: NSPopUpButton!
	@IBOutlet weak var move2Select: NSPopUpButton!
	@IBOutlet weak var move3Select: NSPopUpButton!
	@IBOutlet weak var move4Select: NSPopUpButton!
	
	
	
//	@objc dynamic var weaknessTable:
	
	@objc dynamic var team = [Pokemon]()
	
	@objc dynamic var team2test = Team()
	
	@objc dynamic var teamWeaknessTableBind: [String: [String: Int]] = [:]
	
	@objc dynamic var teamCoverageTableBind: [String: [String: Bool]] = [:]
	
	@objc dynamic var colorTable: [String: NSColor] = ["Weak": NSColor.systemRed,
													   "Resist": NSColor.systemGreen,
													   "Neutral": NSColor.systemGray]
	
	@objc dynamic var itemList = [Item]()
	
	@objc dynamic var learnsetMoves = [Move]()
	
	@objc dynamic var movesToSet = [String: Move]()
	
	@objc dynamic var natureList = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		Dex.initializeDex()
		Dex.defineTypeMatchups()
		MoveDex.initializeMoveDex()
		ItemDex.initializeItemDex()
		for item in ItemDex.itemDexArray {
			itemList.append(item)
//			itemSelectButton.addItem(withTitle: item.name)
		}
		for (nature, _) in Dex.natureList {
			natureList.append(nature)
		}
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
//			updateViewConstraints()
			
		}
	}
	
	
	
	@IBAction func addToTeam(_ sender: Any) {
		if (searchForTeam.stringValue == "") {
			return
		}

		let monToAdd = Dex.searchDex(searchParam: searchForTeam.stringValue)[0]

		self.team.append(monToAdd)
		if team2test.members.isEmpty {
			team2test = Team(members: team)
		} else {
			team2test.addMember(monToAdd)
		}

		team2test.teamWeaknesses = team2test.determineTeamWeaknesses()
		teamWeaknessTableBind[monToAdd.species] = monToAdd.getPokemonWeaknesses(pokemonName: monToAdd)
		teamWeaknessTableBind["Cumulative"] = team2test.determineTeamWeaknesses()

		//---------
		team2test.teamCoverage = team2test.determineTeamCoverage()
	}

	@IBAction func teamTypeTableAction(_ sender: Any) {
		
	}

	
	@IBAction func tableViewAction(_ sender: Any) {
		let index: Int = tableView.selectedRow
		
		if index > -1 {
			let mon: Pokemon = team[index]
			
			// get sprite for selected mon
			let imgFile = dexNumToSprite(mon)
			arrayImage.image = NSImage(imageLiteralResourceName: imgFile!)
			
			//get base stat values for selected mon
			baseHP.stringValue = "\(mon.baseStats["hp"] ?? 0)"
			baseATK.stringValue = "\(mon.baseStats["atk"] ?? 0)"
			baseDEF.stringValue = "\(mon.baseStats["def"] ?? 0)"
			baseSPA.stringValue = "\(mon.baseStats["spa"] ?? 0)"
			baseSPD.stringValue = "\(mon.baseStats["spd"] ?? 0)"
			baseSPE.stringValue = "\(mon.baseStats["spe"] ?? 0)"
			
			// create bar graph level bars for corresponding baseStats
			hpLevel.integerValue = mon.baseStats["hp"]!
			atkLevel.integerValue = mon.baseStats["atk"]!
			defLevel.integerValue = mon.baseStats["def"]!
			spaLevel.integerValue = mon.baseStats["spa"]!
			spdLevel.integerValue = mon.baseStats["spd"]!
			speLevel.integerValue = mon.baseStats["spe"]!
			
			// populate mon type interaction table for selected mon
			let monWeaknessesDict: [String: Int] = mon.getPokemonWeaknesses(pokemonName: mon)
			monImmunities.stringValue = ""
			monResistances.stringValue = ""
			monResistances.textColor = NSColor.systemGreen
			monWeaknesses.stringValue = ""
			monWeaknesses.textColor = NSColor.systemOrange
			for (type, scalar) in monWeaknessesDict {
				if scalar > 1 {
					monWeaknesses.stringValue += "\(type)\n"
				} else if scalar < 0 {
					monResistances.stringValue += "\(type)\n"
				} else if scalar == 0 {
					monImmunities.stringValue += "\(type)\n"
				}
			}
			// populate learnset table for selected mon
			let learnset = mon.getPokemonLearnset(pokemon: mon)
			learnsetMoves = [Move]()
			for move in learnset {
				let moveToAdd = MoveDex.searchMovedex(searchParam: move)
				learnsetMoves.append(moveToAdd)
			}
			
		}
	}
	
	func getEVAllowedChange() -> Bool {
		let evSliderSum: Int = hpSlider.integerValue + atkSlider.integerValue + defSlider.integerValue + spaSlider.integerValue + spdSlider.integerValue + speSlider.integerValue
		if evSliderSum < 510 { return true }
		else { return false }
	}
	
	@IBAction func hpSliderAction(_ sender: Any) {
		hpSlider.minValue = 0.0
		hpSlider.maxValue = 252.0
		hpSlider.numberOfTickMarks = 63
		hpSlider.allowsTickMarkValuesOnly = true

		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["hp"] = hpSlider.integerValue
				print(mon.eVs["hp"]!)
			}
		} else {
			return
//			let defaultPositon = hpSliderCell.rectOfTickMark(at: 4)
//			hpSliderCell.drawKnob(defaultPositon)
		}
	}

	@IBAction func atkSliderAction(_ sender: Any) {
		atkSlider.minValue = 0.0
		atkSlider.maxValue = 252.0
		atkSlider.numberOfTickMarks = 63
		atkSlider.allowsTickMarkValuesOnly = true
		
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["atk"] = atkSlider.integerValue
				print(mon.eVs["atk"]!)
			}
		} else { return }
	}
	
	@IBAction func defSliderAction(_ sender: Any) {
		defSlider.minValue = 0.0
		defSlider.maxValue = 252.0
		defSlider.numberOfTickMarks = 63
		defSlider.allowsTickMarkValuesOnly = true
		
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["def"] = defSlider.integerValue
				print(mon.eVs["def"]!)
			}
		} else { return }
	}
	
	@IBAction func spaSliderAction(_ sender: Any) {
		spaSlider.minValue = 0.0
		spaSlider.maxValue = 252.0
		spaSlider.numberOfTickMarks = 63
		spaSlider.allowsTickMarkValuesOnly = true
		
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["spa"] = spaSlider.integerValue
				print(mon.eVs["spa"]!)
			}
		} else { return }
	}

	@IBAction func spdSliderAction(_ sender: Any) {
		spdSlider.minValue = 0.0
		spdSlider.maxValue = 252.0
		spdSlider.numberOfTickMarks = 63
		spdSlider.allowsTickMarkValuesOnly = true
		
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["spd"] = spdSlider.integerValue
				print(mon.eVs["spd"]!)
			}
		} else { return }
	}

	@IBAction func speSliderAction(_ sender: Any) {
		speSlider.minValue = 0.0
		speSlider.maxValue = 252.0
		speSlider.numberOfTickMarks = 63
		speSlider.allowsTickMarkValuesOnly = true
		
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["spe"] = speSlider.integerValue
				print(mon.eVs["spe"]!)
			}
		} else { return }
	}
	
	
	@IBAction func itemSelectAction(_ sender: Any) {
//		itemSelectButton.selectedItem?.title
	}
	
	@IBAction func move1Selected(_ sender: Any) {
//		movesToSet["move1"] = MoveDex.searchMovedex(searchParam: (move1Select.selectedItem?.title)!)
//		var movesArray = [Move]()
//		for (_, move) in movesToSet {
//			movesArray.append(move)
//		}
//		let index = tableView.selectedRow
//		if index > -1 {
//			let mon = team[index]
//			mon.moves = movesArray
//		}
		teamCoverageTableBind = team2test.determineTeamCoverage()
	}
	@IBAction func move2Selected(_ sender: Any) {
//		movesToSet["move2"] = MoveDex.searchMovedex(searchParam: (move2Select.selectedItem?.title)!)
//		var movesArray = [Move]()
//		for (_, move) in movesToSet {
//			movesArray.append(move)
//		}
//		let index = tableView.selectedRow
//		if index > -1 {
//			let mon = team[index]
//			mon.moves = movesArray
//		}
		teamCoverageTableBind = team2test.determineTeamCoverage()
	}
	@IBAction func move3Selected(_ sender: Any) {
//		movesToSet["move3"] = MoveDex.searchMovedex(searchParam: (move3Select.selectedItem?.title)!)
//		var movesArray = [Move]()
//		for (_, move) in movesToSet {
//			movesArray.append(move)
//		}
//		let index = tableView.selectedRow
//		if index > -1 {
//			let mon = team[index]
//			mon.moves = movesArray
//		}
		teamCoverageTableBind = team2test.determineTeamCoverage()
	}
	@IBAction func move4Selected(_ sender: Any) {
//		movesToSet["move4"] = MoveDex.searchMovedex(searchParam: (move4Select.selectedItem?.title)!)
//		var movesArray = [Move]()
//		for (_, move) in movesToSet {
//			movesArray.append(move)
//		}
//		let index = tableView.selectedRow
//		if index > -1 {
//			let mon = team[index]
//			mon.moves = movesArray
//		}
		teamCoverageTableBind = team2test.determineTeamCoverage()
	}
	
	
	@IBAction func checkToConsole(_ sender: Any) {
		//placeholder function to check whatever needed to console

		print(team2test)
		print(team[0].move1, team[0].move2, team[0].move3, team[0].move4)

		
	}
	
}

extension TeamViewController {
	func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		if commandSelector == #selector(insertNewline(_:)) {
			addToTeam(searchForTeam)
		}
		return false
	}
}

//class MoveTableView: NSTableView {
//	weak var MoveTableDelegate: NSTableViewDelegate?
//
//	override init(frame: NSRect) {
//		super.init(frame: NSRect)
//	}
//
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//
//	override func canDragRows(with rowIndexes: IndexSet, at mouseDownPoint: NSPoint) -> Bool {
//		return true
//	}
//
//}


class TestViewController: NSViewController {

	@IBOutlet weak var arrayImage: NSImageView!
	@IBOutlet weak var arrayContent: NSTextField!
	@IBOutlet weak var tableView: NSTableView!
	

	@objc dynamic var pokedex: [Pokemon] = [Pokemon()]
	
//	@objc dynamic var dexImgFile = dexNumToIcon()

	override func viewDidLoad() {
		super.viewDidLoad()
		Dex.initializeDex()
		MoveDex.initializeMoveDex()
		Dex.defineTypeMatchups()
		
	}
	
	override var representedObject: Any? {
		didSet {
			// Update view if already loaded
		}
	}
	
	
	
	
	@IBAction func tableViewAction(_ sender: Any) {
		let index: Int = tableView.selectedRow
		
		if index > -1 {
			let mon: Pokemon = pokedex[index]
			arrayContent.stringValue = "\(mon.species)\nHP: \(mon.baseStats["hp"] ?? 0)\nATK: \(mon.baseStats["atk"] ?? 0)\nDEF: \(mon.baseStats["def"] ?? 0)\nSPA: \(mon.baseStats["spa"] ?? 0)\nSPD: \(mon.baseStats["spd"] ?? 0)\nSPE: \(mon.baseStats["spe"] ?? 0)\n\nAbilities: \(mon.abilities)\nTypes: \(mon.types)"
			let imgFile = dexNumToIcon(mon)
			//let img = NSImage.init(name: imgFile!)
			//arrayImage.image?.setName(imgFile)
			arrayImage.image = NSImage(imageLiteralResourceName: imgFile!)
			
		}
		else {
			arrayContent.stringValue = ""
		}
	}
	@IBAction func populateDexTable(_ sender: Any) {
		for mon in Dex.dexArray {
			self.pokedex.append(mon)
		}
		super.viewDidLoad()
	}
	

	
}

	
	
	

