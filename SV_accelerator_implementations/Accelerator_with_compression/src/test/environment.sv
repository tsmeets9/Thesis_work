
class Environment #(config_t cfg);

  virtual intf #(cfg) intf_i;

  // instantiate TB blocks
  Generator #(cfg) gen;
  Driver    #(cfg) drv;
  Monitor   #(cfg) mon;
  Checker   #(cfg) chk;
  Scoreboard scb;

  // instantiate mailboxes for communication between TB blocks
  mailbox #(Transaction_Feature #(cfg)) gen2drv_feature;
  mailbox #(Transaction_Masks #(cfg)) gen2drv_masks;
  mailbox #(Transaction_Kernel #(cfg)) gen2drv_kernel;
  mailbox #(Transaction_Output_Encoded #(cfg)) mon2chk_encoded;
  mailbox #(Transaction_Output_Masks #(cfg)) mon2chk_masks;

  mailbox #(bit)chk2scb;

  // constructor
  function new(virtual intf #(cfg) i);

    intf_i = i;

    // construct mailboxes
    // number in the parantheses indicate the depth of mailboxes
    gen2drv_feature = new(5);
    gen2drv_masks   = new(5);
    gen2drv_kernel  = new(5);
    mon2chk_encoded = new(5);
    mon2chk_masks   = new(5);
    chk2scb         = new(5);

    // construct TB blocks and pass mailboxes to be used for communication
    gen = new(gen2drv_feature, gen2drv_masks, gen2drv_kernel);
    drv = new(i, gen2drv_feature, gen2drv_masks, gen2drv_kernel);
    mon = new(i, mon2chk_encoded, mon2chk_masks);
    chk = new(mon2chk_encoded, mon2chk_masks, chk2scb);
    scb = new(chk2scb);
  endfunction : new


  //run task
  task run;
    $display("[ENV] start-of-life");
    pre_test();
    test();
    post_test();
    $display("[ENV] end-of-life");
    repeat (100) @(intf_i.cb);
    $finish;
  endtask

  task pre_test();
    drv.reset();
  endtask

  task test();
    // fork to run all the blocks in parallel
    fork
    begin
      fork
        gen.run();  // runs forever
        drv.run();  // runs forever
        mon.run();  // runs forever
        chk.run();  // runs forever
        scb.run();  // runs until NO_tests is reached
      join_any // join when scoreboard ends it's execution
      disable fork;
    end
    join
  endtask

  task post_test();
    scb.showReport();
  endtask

endclass : Environment
