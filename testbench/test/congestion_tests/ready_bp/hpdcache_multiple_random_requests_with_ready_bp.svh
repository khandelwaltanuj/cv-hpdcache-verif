// ----------------------------------------------------------------------------
//Copyright 2024 CEA*
//*Commissariat a l'Energie Atomique et aux Energies Alternatives (CEA)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
//[END OF HEADER]
// ----------------------------------------------------------------------------
//  Description : This tests random access to the HPDCACHE
// ----------------------------------------------------------------------------

`ifndef __test_hpdcache_multiple_random_requests_with_ready_bp_SVH__
`define __test_hpdcache_multiple_random_requests_with_ready_bp_SVH__

class test_hpdcache_multiple_random_requests_with_ready_bp extends test_hpdcache_multiple_random_requests;

  `uvm_component_utils(test_hpdcache_multiple_random_requests_with_ready_bp)

// -------------------------------------------------------------------------
  // Constructor
  // -------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    set_type_override_by_type(hpdcache_txn::get_type(), hpdcache_cacheable_only_txn::get_type());
  endfunction: new

  virtual task pre_reset_phase(uvm_phase phase);
    super.pre_reset_phase(phase);

    // force NoC ready to 0
    m_read_bp_vif.force_bp_out(1'b1);
    m_write_req_bp_vif.force_bp_out(1'b1);
    m_write_data_bp_vif.force_bp_out(1'b1);
  endtask

  virtual task main_phase(uvm_phase phase);
  
    
    fork 
    begin
      phase.raise_objection(this);
      vif.wait_n_clocks(1000); 
      
      //release ready signals
      m_read_bp_vif.release_bp_out();
      m_write_req_bp_vif.release_bp_out();
      m_write_data_bp_vif.release_bp_out();

      phase.drop_objection(this);
    end 
    join_none
    super.main_phase(phase);

     phase.raise_objection(this);

    #200000ns;
    phase.drop_objection(this, "Completed sequences");

  endtask

endclass: test_hpdcache_multiple_random_requests_with_ready_bp

`endif // __test_hpdcache_multiple_random_requests_with_ready_bp_SVH__