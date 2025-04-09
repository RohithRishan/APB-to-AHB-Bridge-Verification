
//Extends env class from  uvm_env
class env extends uvm_env;

	//Factory Registration
        `uvm_component_utils(env)

        ahb_agt_top ahb_top;
        apb_agt_top apb_top;
 
        env_config e_cfg;

	//Standard UVM Methods
        extern function new(string name = "env", uvm_component parent);
        extern function void build_phase (uvm_phase phase);
       

endclass

//-----------Constructor-----------//
	function env::new(string name = "env", uvm_component parent);
        	super.new(name, parent);
endfunction

//-----------Build Phase-----------//
	function void  env::build_phase(uvm_phase phase);
        	super.build_phase(phase);

        	if(!uvm_config_db #(env_config)::get(this, "", "env_config", e_cfg))
                `uvm_fatal("env", "cannot get the env_config")

        	if(e_cfg.has_ahb_agent)
        	begin
                	ahb_top = ahb_agt_top::type_id::create("ahb_top", this);
 	  //             uvm_config_db #(ahb_agt_config)::set(this, "*agt*", "ahb_agt_config", e_cfg.ahb_cfg);
        	end
		if(e_cfg.has_apb_agent)
       		 begin
                	apb_top = apb_agt_top::type_id::create("apb_top", this);
   	 //             uvm_config_db #(apb_agt_config)::set(this, "agt*", "apb_agt_config", e_cfg.apb_cfg);
        	end

endfunction


