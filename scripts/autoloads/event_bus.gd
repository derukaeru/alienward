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

signal open_patient_screen
signal close_patient_screen

signal throw_item
signal open_curtain(index: int)
signal close_curtain(index: int)

signal deliver_child(index: int, baby: Baby)
