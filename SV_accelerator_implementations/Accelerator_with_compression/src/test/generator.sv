// parameterized class
class Generator #(config_t cfg);

  mailbox #(Transaction_Feature #(cfg)) gen2drv_feature;
  mailbox #(Transaction_Masks #(cfg)) gen2drv_masks;
  mailbox #(Transaction_Kernel #(cfg)) gen2drv_kernel;

  int fd;
  int counter;
  // class constructor
  function new( 
    mailbox #(Transaction_Feature #(cfg)) g2d_feature,
    mailbox #(Transaction_Masks #(cfg)) g2d_masks,
    mailbox #( Transaction_Kernel #(cfg)) g2d_kernel
  );
    gen2drv_feature = g2d_feature;
    gen2drv_masks = g2d_masks;
    gen2drv_kernel  = g2d_kernel;

  endfunction : new

  task run();
    // instantiate and randomize kernel once
    Transaction_Kernel #(cfg) tract_kernel;
    Transaction_Masks #(cfg) tract_masks;
    tract_kernel = new();
    tract_masks = new();
    //tract_kernel.randomize();

    $display("[DRV] -----  Start execution -----");
    fd = $fopen ("weights.txt", "r");
    if (fd) $display("File was opened succesfully : %0d", fd);
    else $display("File was NOT opened succesfully : %0d", fd);
    

    for(int ky=0;ky<cfg.KERNEL_SIZE; ky++) begin
      for(int kx=0;kx<cfg.KERNEL_SIZE; kx++) begin
        for(int inch=0;inch<cfg.INPUT_NB_CHANNELS; inch++) begin
          for (int outch = 0; outch < cfg.OUTPUT_NB_CHANNELS; outch++) begin
              string line;
              logic [cfg.DATA_WIDTH-1:0] kernel_element; 
              $fgets(line, fd);
              //$display("Line read : %s", line);
              kernel_element = line.atobin();
              //$display("Line read : %b", kernel_element);
              tract_kernel.kernel[ky][kx][inch][outch] = kernel_element;
          end
        end
      end
    end

    $fclose(fd);
            
    gen2drv_kernel.put(tract_kernel);

    fd = $fopen ("activations_mask.txt", "r");
    if (fd) $display("File was opened succesfully : %0d", fd);
    else $display("File was NOT opened succesfully : %0d", fd);
    

    for (int i = 0; i < (((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.INPUT_NB_CHANNELS/8); i++) begin
      string line;
      logic [cfg.MEM_BW-1:0] masks_element; 
      $fgets(line, fd);
      //$display("Line read : %s", line);
      masks_element = line.atobin();
      //$display("Line read : %b", masks_element);
      tract_masks.masks[i] = masks_element;
    end

    $fclose(fd);
            
    gen2drv_masks.put(tract_masks);

    
    forever
    begin
      // instantiate and randomize features until simulation ends
      Transaction_Feature #(cfg) tract_feature;
      tract_feature = new();
      //tract_feature.randomize();
      fd = $fopen ("activations_encoded.txt", "r");
      if (fd) $display("File activations _encoded was opened succesfully : %0d", fd);
      else $display("File was NOT opened succesfully : %0d", fd);
      counter = 0;
      while (!$feof(fd)) begin 
        string line;
        logic [cfg.MEM_BW-1:0] activations_element; 
        $fgets(line, fd);
        // $display("Line read : %s", line);
        activations_element = line.atobin();
        //$display("Line read : %b", activations_element);
        tract_feature.inputs[counter] = activations_element;
        counter += 1;
      end
      $fclose(fd);
      gen2drv_feature.put(tract_feature);
    end
  endtask : run

endclass : Generator
