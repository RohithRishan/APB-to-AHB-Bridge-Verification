 
//class test extends from uvm_test
 class test extends uvm_test;

	//Factory Registration
	`uvm_component_utils(test)

	//Declared the handles
	env_config m_cfg;
	env e_cfg;
	//ahb_seqs seq;

	ahb_agt_config ahb_cfg[];
	apb_agt_config apb_cfg[];

	//Parameters
	int no_of_ahb_agents=1;
	int no_of_apb_agents=1;
	bit has_scoreboard=1;
	bit has_virtual_sequencer=1;

	//Standard UVM Methods
	extern function new(string name="test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);


endclass

//----------Constructor-----------//
	function test::new(string name="test",uvm_component parent);
		super.new(name,parent);
endfunction

//-----------Build Phase----------//
	function void test::build_phase(uvm_phase phase);
		super.build_phase(phase);	

		m_cfg = env_config::type_id::create("env_config", this);
        	e_cfg = env::type_id::create("env", this);
	//these shud be written before declaring dynamic array

		if(m_cfg.has_ahb_agent)
		begin
			m_cfg.ahb_cfg=new[no_of_ahb_agents];
		end
	
		if(m_cfg.has_apb_agent)
		begin
			m_cfg.apb_cfg=new[no_of_apb_agents];
		end
	
	//m_cfg = env_config::type_id::create("env_config", this);
	//e_cfg = env::type_id::create("env", this);

		ahb_cfg=new[no_of_ahb_agents];
		apb_cfg=new[no_of_apb_agents];
	
		foreach(apb_cfg[i])
		begin
			apb_cfg[i]=apb_agt_config::type_id::create($sformatf("apb_cfg[%0d]",i));
			if(!uvm_config_db #(virtual apb_if)::get(this,"","apb_vif",apb_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");

			apb_cfg[i].is_active=UVM_ACTIVE;
			m_cfg.apb_cfg[i]=apb_cfg[i];

		end
	
		foreach(ahb_cfg[i])
		begin
			ahb_cfg[i]=ahb_agt_config::type_id::create($sformatf("ahb_cfg[%0d]",i));
			if(!uvm_config_db #(virtual ahb_if)::get(this,"","ahb_vif",ahb_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");

			ahb_cfg[i].is_active=UVM_ACTIVE;
			m_cfg.ahb_cfg[i]=ahb_cfg[i];
	
		end
		
		m_cfg.no_of_ahb_agents=no_of_ahb_agents;
		m_cfg.no_of_apb_agents=no_of_apb_agents;
		m_cfg.has_scoreboard=has_scoreboard;
		m_cfg.has_virtual_sequencer=has_virtual_sequencer;
	
		uvm_config_db#(env_config) ::set(this,"*","env_config",m_cfg);
endfunction

//-------------end_of_elaboration_phase------------------//
	function void test::end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology;
endfunction

//-------------------------------------------------------//
//-------------------- Test Cases -----------------------------//

//test1 extends from test class
class test1 extends test;
	
	//Factory registration
	`uvm_component_utils(test1)

//-------------- Constructor method --------------------//
	function new(string name="test1",uvm_component parent);
		super.new(name,parent);
endfunction
	
//	single_sequence seq1;
//----------------- run_phase -------------------//
	task run_phase(uvm_phase phase);
		begin
		repeat(5)
		begin
			single_sequence seq1;
        		seq1=single_sequence::type_id::create("seq1");
        		phase.raise_objection(this);
        		seq1.start(e_cfg.ahb_top.agt[0].ahb_seqr);
        		phase.drop_objection(this);
		end
		end
endtask

endclass

//------------------------------------------------------//
//test2 extends from test
class test2 extends test;
	
	//Factory Registration
	`uvm_component_utils(test2)

	incr_wrap_sequence seq2;

//----------- Constructor ----------------------------//
	function new(string name="test2",uvm_component parent);
		super.new(name,parent);
endfunction

//-------------run_phase------------------------//
	task run_phase(uvm_phase phase);
		begin
		repeat(5)
		begin
        		seq2=incr_wrap_sequence::type_id::create("seq2");
        		phase.raise_objection(this);
        		seq2.start(e_cfg.ahb_top.agt[0].ahb_seqr);
        		phase.drop_objection(this);
		end
		end
endtask

endclass

//-----------------------------------------------------------//
//test3 extends from test
class test3 extends test;
	
	//Factory Registration
	`uvm_component_utils(test3)

	unspecified_sequence seq3;

//------------------- Constructor-------------------//
	function new(string name="test3",uvm_component parent);
		super.new(name,parent);
endfunction

//------------------ run_phase--------------------//
	task run_phase(uvm_phase phase);
		begin
		repeat(5)
		begin
        		seq3=unspecified_sequence::type_id::create("seq3");
        		phase.raise_objection(this);
        		seq3.start(e_cfg.ahb_top.agt[0].ahb_seqr);
        		phase.drop_objection(this);
		end
		end
endtask

endclass


	


