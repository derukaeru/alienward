extends Node

signal open_shop
signal close_shop
signal shop_buy_item(item_name: String)

signal open_microscope
signal close_microscope
signal create_new_dna
signal identify_bacteria(bacteria: Bacteria)
signal show_dna(dna_index: int)

signal open_antidote_stand
signal close_antidote_stand
signal update_base_antidote_item_name(antidote_name: String)
signal generate_antidote(data: Dictionary)

signal generate_image(patient_id: int)
signal clean_mop
signal done_cleaning

signal pick_up_baby_from_delivery_table(baby: Baby)
signal add_entity_to_container(entity: Node)

signal open_patient_screen(patient: Patient)
signal open_incubator_screen(incubator: Incubator)

signal throw_item
signal open_curtain(index: int)
signal close_curtain(index: int)

signal deliver_child(index: int, baby: Baby)
signal incubated_child(id: int)
signal patient_scanned(patient_id: int)
signal generate_item(item_id: String)

signal patient_to_ward(id: int)
signal patient_to_clinic(id: int)

signal patient_reached_ward(id: int)
signal patient_reached_clinic(id: int)

signal patient_leaving_ward(id: int)
signal patient_leaving_checkup(id: int)
signal left(id: int)

signal add_subtitle(text: String)
signal stop_player_movement
signal player_can_move

signal npc_reached_ward(id: int)

signal add_end_screen_details(served_patients: int, dirtiness: float, patient_satisfaction: float, money_earned: int)
