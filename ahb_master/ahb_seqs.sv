
//Base sequence is extend from uvm_sequenc with parameterized class
//----------------------Base sequence------------------------//
class base_sequence_ahb extends uvm_sequence #(ahb_xtn);

	//Factory Registration
        `uvm_object_utils(base_sequence_ahb)
             
		//ahb_signals(local varaibales/signal)
	        logic [31:0] haddr;
                logic [2:0] hsize;
                logic [2:0] hburst;
		logic hwrite;	

	//Standard UVM methods
        extern function new(string name = "base_sequence_ahb");

endclass

//--------------- Constructor method----------------------//
	function base_sequence_ahb::new(string name = "base_sequence_ahb");
        	super.new(name);
endfunction


//---------------------------------------------------------------------------------------------//
//--------------------Single_sequence ---------------------------------//
class single_sequence extends base_sequence_ahb;

	//Factory Registration
	`uvm_object_utils(single_sequence)

	//Standard UVM Methods
	extern function new(string name = "single_sequence");
        extern task body();

endclass

//----------------Constructor---------------//
	function single_sequence::new(string name = "single_sequence");
        	super.new(name);
endfunction

//--------------- task body-----------------//
	task single_sequence::body();

        	repeat(5)
        	begin
        		req = ahb_xtn::type_id::create("req");

        		start_item(req);
        		assert(req.randomize() with {Htrans == 2'b10 && 
							Hburst == 3'b000 && 
							Hwrite == 1;}); //first transaction is NS
        		finish_item(req);

        	end
endtask


//--------------------------------------------------------------------------------------------------//
//----------------------  unspecified_sequence  ---------------------//
class  unspecified_sequence extends base_sequence_ahb;

  	// Factory Registration
	`uvm_object_utils(unspecified_sequence)

        // Standard UVM Methods:
	extern function new(string name = "unspecified_sequence");
	extern task body();

endclass

//-----------------  constructor new method  -------------------//
 	function  unspecified_sequence::new(string name = "unspecified_sequence");
		super.new(name);
endfunction

//----------------- Body() task method   ----------------------//
	task  unspecified_sequence::body();
	
		req = ahb_xtn::type_id::create("req");

		start_item(req);
		assert(req.randomize() with {Htrans == 2'b10; 
						Hburst == 3'b001; 
						Hwrite == 1'b1;});
		finish_item(req);


		//Store the value in Local variables
		haddr  = req.Haddr;
		hwrite = req.Hwrite;
		hsize  = req.Hsize;
		hburst = req.Hburst;


	//------ Unspecified_length INCR ---------//
	if(hburst == 3'b001)
	begin
		for(int i=0;i<req.length-1;i++)
		begin
			start_item(req);

			if(hsize == 0)
				assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst; 
								Hwrite == hwrite; 
								Haddr == haddr + 1'b1;});

			if(hsize == 1)
				assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst; 
								Hwrite == hwrite;
								Haddr == haddr + 2'b10;});

			if(hsize == 2)
				assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
								Hwrite == hwrite; 
								Haddr == haddr + 3'b100;});

			finish_item(req);

			haddr = req.Haddr;
		end
	end

endtask


//-----------------------------------------------------------------------------------//
//----------------------------increment and wrapping sequence----------------------//
class incr_wrap_sequence extends base_sequence_ahb;

	//Factory Registration
        `uvm_object_utils(incr_wrap_sequence)

	//Standard UVM Methods
        extern function new(string name = "incr_wrap_sequence");
        extern task body();

endclass

//--------------Constructor--------------------//
	function incr_wrap_sequence::new(string name = "incr_wrap_sequence");
        	super.new(name);
endfunction

//------------------- task body---------------------//
	task incr_wrap_sequence::body();
		repeat(5)
		begin
        		req = ahb_xtn::type_id::create("req");

        		start_item(req);
			assert(req.randomize() with {Htrans == 2'b10 && 
							Hburst inside {[2:7]} && 
							Hwrite == 1;});
			finish_item(req);
		end

        //store in local variables
        haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

//------------------------ INCR 4 ----------------------------//
		if(hburst == 3'b011)
        	begin
                	for(int i=0; i<3; i++)
                	begin
                        	//haddr = haddr + (2**hsize);
                        	start_item(req);
				if(hsize == 0)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == haddr + 1'b1;});

                        	if(hsize == 1)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == haddr + 2'b10;});

                        	if(hsize == 2)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == haddr +3'b100;});
                        	finish_item(req);

                        	haddr = req.Haddr;
                	end
        	end

//--------------------------------------INCR 8--------------------------------//
        if(hburst == 3'b101)
        begin
                for(int i=0; i<7; i++)
                begin
                        //haddr = haddr + (2**hsize);

                        start_item(req);
                        if(hsize == 0)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == haddr + 1'b1;});

                        if(hsize == 1)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == haddr + 2'b10;});

                        if(hsize == 2)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == haddr + 3'b100;});

                        finish_item(req);
 			haddr = req.Haddr;
                end
        end

//------------------------------------INCR 16------------------------------------//
        if(hburst == 3'b111)
        begin
                for(int i=0; i<15; i++)
                begin
                        //haddr = haddr + (2**hsize);

                        start_item(req);
	                if(hsize == 0)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == haddr + 1'b1;});

                        if(hsize == 1)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == haddr + 2'b10;});

                        if(hsize == 2)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == haddr + 3'b100;});

                        finish_item(req);

                        haddr = req.Haddr;
                end
        end

//--------------------------------------------------------------------------------------//
//--------------------------------WRAP 4----------------------------///
	 if(hburst == 3'b010)
          begin
                for(int i=0; i<3; i++)
                begin
                        start_item(req);
                          if(hsize == 0)
                                assert(req.randomize() with {Hsize == hsize;
                                                                Hburst == hburst;
                                                                Hwrite == hwrite;
                                                                Htrans == 2'b11;
                                                                Haddr == {haddr[31:2], haddr[1:0] + 1'b1};});

                        if(hsize == 1)
                                assert(req.randomize() with {Hsize == hsize;
                                                                Hburst == hburst;
                                                                Hwrite == hwrite;
                                                                Htrans == 2'b11;
                                                                Haddr == {haddr[31:3], haddr[2:0] + 2'b10};});

                        if(hsize == 2)
                                assert(req.randomize() with {Hsize == hsize;
                                                                Hburst == hburst;
                                                                Hwrite == hwrite;
                                                                Htrans == 2'b11;
                                                                Haddr == {Haddr[31:4], haddr[3:0] + 3'b100};});

                        finish_item(req);

                        haddr = req.Haddr;
                 end
          end
 

//---------------------- WRAP 8 ------------------------------//
	 if(hburst == 3'b100)
        begin
                for(int i=0; i<7; i++)
                begin
                        start_item(req);
                          if(hsize == 0)
                                assert(req.randomize() with {Hsize == hsize;
                                                                Hburst == hburst;
                                                                Hwrite == hwrite;
                                                                Htrans == 2'b11;
                                                                Haddr == {haddr[31:3], haddr[2:0] + 1'b1};});

                        if(hsize == 1)
                                assert(req.randomize() with {Hsize == hsize;
                                                                Hburst == hburst;
                                                                Hwrite == hwrite;
                                                                Htrans == 2'b11;
                                                                Haddr == {haddr[31:4], haddr[3:0] + 2'b10};});

                        if(hsize == 2)
                                assert(req.randomize() with {Hsize == hsize;
                                                                Hburst == hburst;
                                                                Hwrite == hwrite;
                                                                Htrans == 2'b11;
                                                                Haddr == {Haddr[31:5], haddr[4:0] + 3'b100};});

                        finish_item(req);

                        haddr = req.Haddr;
                end
        end

//-----------------------WRAP 16--------------------------------///
        if(hburst == 3'b110)
        begin
                for(int i=0; i<15; i++)
                begin
			start_item(req);
		          if(hsize == 0)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == {haddr[31:4], haddr[3:0] + 1'b1};});

			if(hsize == 1)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == {haddr[31:5], haddr[4:0] + 2'b10};});

                        if(hsize == 2)
                                assert(req.randomize() with {Hsize == hsize; 
								Hburst == hburst;
                                                                Hwrite == hwrite; 
								Htrans == 2'b11;
                                                                Haddr == {Haddr[31:6], haddr[5:0] + 3'b100};});

                        finish_item(req);

                        haddr = req.Haddr;
        	end
        end
 
endtask

