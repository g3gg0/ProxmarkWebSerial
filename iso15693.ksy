meta:
  id: iso15693
  title: ISO15693 NFC protocol
  endian: le
  
seq:
  - id: request_response
    type: request_response
    repeat: expr
    repeat-expr: 3

types:
  request_response:
    seq:
      - id: req_len
        type: u1
      - id: req
        type: request
      - id: res_len
        type: u1
      - id: res
        type:
          switch-on: req.command
          cases:
            'command_type::inventory': res_inventory
            'command_type::get_system_information': res_get_system_information
            'command_type::read_single_block': res_read_single_block
            _: res_empty
        
  request:
    seq:
      - id: flags
        type: req_flags
      - id: command
        type: u1
        enum: command_type
      - id: manufacturer_code
        type: u1
        enum: manufacturer_code_type
        if: command.to_i  >= 0xA0
      - id: uid
        type: u8
        if: flags.address_slots == true and flags.inventory == false
      - id: payload
        type:
          switch-on: command
          cases:
            'command_type::inventory': req_inventory
            'command_type::read_single_block': req_read_single_block
            'command_type::write_single_block': req_write_single_block
            'command_type::lock_block': req_lock_block
            'command_type::write_dsfid': req_write_dsfid
            'command_type::read_multi_block': req_read_multi_block
            'command_type::write_multi_block': req_write_multi_block
            'command_type::nxp_set_password': req_nxp_set_password
            'command_type::nxp_write_password': req_nxp_write_password
            'command_type::nxp_lock_password': req_nxp_lock_password
            'command_type::nxp_destroy': req_nxp_destroy
            'command_type::nxp_enable_privacy': req_nxp_enable_privacy
            'command_type::nxp_write_eas_id': req_nxp_write_eas_id
            _: no_payload
      - id: crc
        type: u2

  no_payload:
    seq:
      - id: dummy
        size: 0
        
  res_empty:
    seq:
      - id: flags
        type: res_flags
      - id: error_code
        type: u8
        if: flags.error
      - id: crc
        type: u2

  ################ Flags ################ 
  req_flags:
    doc: general request flags, defined in ISO15693-3 7.3.2
    seq:
      - id: rfu
        type: b1
      - id: option
        type: b1
      - id: address_slots
        type: b1
        doc: dual-use, depending on inventory flag, which comes after
      - id: select_afi
        type: b1
        doc: dual-use, depending on inventory flag, which comes after
      - id: protocol_extension
        type: b1
      - id: inventory
        type: b1
      - id: data_rate
        type: b1
      - id: sub_carrier
        type: b1
        
  res_flags:
    doc: general response flags, defined in ISO15693-3 7.4.2
    seq:
      - id: rfu
        type: b1
      - id: waiting_time_extension
        type: b1
      - id: block_security_status
        type: b2
      - id: extension
        type: b1
      - id: final_response
        type: b1
      - id: responsebuffer_validity
        type: b1
      - id: error
        type: b1
        
  ################ Inventory ################ 
  req_inventory:
    seq:
      - id: afi
        type: u1
        if: _parent.flags.select_afi == true
      - id: mask_length
        type: u1
      - id: mask
        size: mask_length/8
        
  res_inventory:
    seq:
      - id: flags
        type: res_info_flags
      - id: dsfid
        type: u1
      - id: uid
        type: u8
      - id: crc
        type: u2
        
  ################ Get System Information ################ 
  res_get_system_information:
    seq:
      - id: flags
        type: res_flags
      - id: info_flags
        type: res_info_flags
      - id: uid
        type: u8
      - id: dsfid
        type: u1
        if: info_flags.dsfid
      - id: afi
        type: u1
        if: info_flags.afi
      - id: vicc_memory_size
        type: res_vicc_memory_size
        if: info_flags.vicc_memory_size
      - id: ic_reference
        type: u1
        if: info_flags.ic_reference
      - id: crc
        type: u2
        
  res_info_flags:
    seq:
      - id: prop1
        type: b1
      - id: prop2
        type: b1
      - id: prop3
        type: b1
      - id: prop4
        type: b1
      - id: ic_reference
        type: b1
      - id: vicc_memory_size
        type: b1
      - id: afi
        type: b1
      - id: dsfid
        type: b1
        
        
  res_vicc_memory_size:
    seq:
      - id: proprietary
        type: b3
      - id: block_size
        type: b5
      - id: block_count
        type: b8
        
        
  ################ Lock Block ################ 
  req_lock_block:
    seq:
      - id: block
        type: u1
        
  ################ Read Block ################ 
  req_read_single_block:
    seq:
      - id: block
        type: u1
        
  res_read_single_block:
    seq:
      - id: flags
        type: res_info_flags
      - id: data
        size: _parent.res_len - 3
      - id: crc
        type: u2
       
  ################ Write Block ################  
  req_write_single_block:
    seq:
      - id: block
        type: u1
        
  ################ Write DSFID ################  
  req_write_dsfid:
    seq:
      - id: dsfid
        type: u1
        
  ################ Read Multiple Blocks ################ 
  req_read_multi_block:
    seq:
      - id: block
        type: u1
        
  ################ Write Multiple Blocks ################ 
  req_write_multi_block:
    seq:
      - id: block
        type: u1
        
        
  ################ NXP SLIX: Set Password ################ 
  req_nxp_set_password:
    seq:
      - id: password_id
        type: u1
        enum: nxp_password_type
      - id: password_xor
        type: u4
        
  ################ NXP SLIX: Write Password ################ 
  req_nxp_write_password:
    seq:
      - id: password_id
        type: u1
        enum: nxp_password_type
      - id: password
        type: u4
        
  ################ NXP SLIX: Lock Password ################ 
  req_nxp_lock_password:
    seq:
      - id: password_id
        type: u1
        enum: nxp_password_type
       
  ################ NXP SLIX: Destroy ################  
  req_nxp_destroy:
    seq:
      - id: password_xor
        type: u4
    
  ################ NXP SLIX: Enable Privacy ################      
  req_nxp_enable_privacy:
    seq:
      - id: password_xor
        type: u4
        
  ################ NXP SLIX: Write EAS ID ################ 
  req_nxp_write_eas_id:
    seq:
      - id: eas_id
        type: u2
        
        

enums:
  # https://en.wikipedia.org/wiki/ISO/IEC_15693
  manufacturer_code_type:
    0x01: motorola
    0x02: stmicroelectronics
    0x03: hitachi
    0x04: nxp_semiconductors
    0x05: infineon_technologies
    0x06: cylink
    0x07: texas_instruments
    0x08: fujitsu
    0x09: matsushita_electronics_corporation_semiconductor
    0x0a: nec
    0x0b: oki_electric_industry
    0x0c: toshiba
    0x0d: mitsubishi_electric
    0x0e: samsung_electronics
    0x0f: hynix
    0x10: lg_semiconductors
    0x11: emosyn_em_microelectronics
    0x12: inside_technology
    0x13: orga_kartensysteme
    0x14: sharp
    0x15: atmel
    0x16: em_microelectronic_marin
    0x17: smartrac_technology
    0x18: zmd
    0x19: xicor
    0x1a: sony
    0x1b: malaysia_microelectronic_solutions
    0x1c: emosyn
    0x1d: shanghai_fudan_microelectronics
    0x1e: magellan_technology
    0x1f: melexis
    0x20: renesas_technology
    0x21: tagsys
    0x22: transcore
    0x23: shanghai_belling
    0x24: masktech_germany
    0x25: innovision_research_and_technology
    0x26: hitachi_ulsi_systems
    0x27: yubico
    0x28: ricoh
    0x29: ask
    0x2a: unicore_microsystems
    0x2b: dallas_semiconductor_maxim
    0x2c: impinj
    0x2d: rightplug_alliance
    0x2e: broadcom
    0x2f: mstar_semiconductor
    0x30: beedar_technology
    0x31: rfidsec
    0x32: schweizer_electronic
    0x33: amic_technology
    0x34: mikron
    0x35: fraunhofer_institute_for_photonic_microsystems
    0x36: ids_microship
    0x37: kovio
    0x38: hmt_microelectronic
    0x39: silicon_craft_technology
    0x3a: advanced_film_device
    0x3b: nitecrest
    0x3c: verayo
    0x3d: hid_global
    0x3e: productivity_engineering
    0x3f: austriamicrosystems
    0x40: gemalto
    0x41: renesas_electronics
    0x42: threealogics
    0x43: top_troniq_asia
    0x44: gentag
    0x45: invengo_information_technology
    0x46: guangzhou_sysur_microelectronics
    0x47: ceitec
    0x48: shanghai_quanray_electronics
    0x49: mediatek
    0x4a: angstrem
    0x4b: celisic_semiconductor
    0x4c: legic_identsystems
    0x4d: balluff
    0x4e: oberthur_technologies
    0x4f: silterra_malaysia
    0x50: delta
    0x51: giesecke_devrient
    0x52: shenzhen_china_vision_microelectronics
    0x53: shanghai_feiju_microelectronics
    0x54: intel
    0x55: microsensys
    0x56: sonix_technology
    0x57: qualcomm_technologies
    0x58: realtek_semiconductor
    0x59: freevision_technologies
    0x5a: giantec_semiconductor
    0x5b: jsc_angstrem_t
    0x5c: starchip
    0x5d: spirtech
    0x5e: gantner_electronic
    0x5f: nordic_semiconductor
    0x60: verisiti
    0x61: wearlinks_technology
    0x62: userstar_information_systems
    0x63: pragmatic_printing
    0x64: associacao_do_laboratorio_de_sistemas_integraveis_tecnologico
    0x65: tendyron
    0x66: muto_smart
    0x67: on_semiconductor
    0x68: tubitak_bilgem
    0x69: huada_semiconductor
    0x6a: seveney
    0x6b: issm
    0x6c: wisesec
    0x7e: holtek


  command_type:
    0x01: inventory
    0x02: stay_quiet
    0x20: read_single_block
    0x21: write_single_block
    0x22: lock_block
    0x23: read_multi_block
    0x24: write_multi_block
    0x25: select
    0x26: reset_to_ready
    0x27: write_afi
    0x28: lock_afi
    0x29: write_dsfid
    0x2A: lock_dsfid
    0x2B: get_system_information
    0x2C: read_multi_secstatus
    0xA2: nxp_set_eas
    0xA3: nxp_reset_eas
    0xA4: nxp_lock_eas
    0xA5: nxp_eas_alarm
    0xA6: nxp_password_protect_eas_afi
    0xA7: nxp_write_eas_id
    0xB0: nxp_inventory_page_read
    0xB1: nxp_inventory_page_read_fast
    0xB2: nxp_get_random_number
    0xB3: nxp_set_password
    0xB4: nxp_write_password
    0xB5: nxp_lock_password
    0xB9: nxp_destroy
    0xBA: nxp_enable_privacy

  nxp_password_type:
    0x01: read
    0x02: write
    0x04: privacy
    0x08: destroy
    0x10: eas_afi

