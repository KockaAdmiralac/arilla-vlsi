`include "uvm_macros.svh"

import uvm_pkg::*;

class generator extends uvm_sequence;
    `uvm_object_utils(generator)

    function new(string name = "generator");
        super.new(name);
    endfunction

    int totalItems = 2000;

    virtual task body();
        for (int i = 0; i < totalItems; i++) begin
            ps2_item item = ps2_item::type_id::create("item");
            start_item(item);
            item.randomize();
            `uvm_info("Generator", $sformatf("Item %0d/%0d created with data %h", i + 1, totalItems, item.data), UVM_LOW);
            finish_item(item);
        end
    endtask
endclass
