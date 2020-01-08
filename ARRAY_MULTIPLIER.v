`timescale 1ns / 1ps
module ARRAY_MULTIPLIER #(parameter bits = 128) (
    input [bits-1:0] a, b,
    output [bits*2-1:0] p
);

//rows means the partial sums
//for 4-bit adder:
//carries[1][0] is the carry out from the rightmost halfadder in the 1st partial sum

//DECLARING: [index] carries [rows]
//ACCESSING: carries[rows][index]

wire [bits-1:0]     carries [bits-1:1];
wire [bits*2-1:0]   sums [bits-1:1];

assign p[0] = a[0] & b[0]; //always true

genvar i,j;
generate
    for(i=1; i < bits; i=i+1) begin : GEN_PARTIALS
        for(j=0; j < bits; j=j+1) begin: GEN_ADDERS   
             
            //FIRST LEVEL OF PARTIAL SUMS
            if(i==1) begin 
            
                //FIRST ADDER
                if(j==0) begin
                    ADD_HALF INSTF_HA_FIRST (
                        .a(a[i]&b[j]),
                        .b(a[i-1]&b[i]),
                                        
                        .sum(p[i]),
                        .cout(carries[i][j])
                    );            
                end 
                
                //LAST ADDER
                else if(j==(bits-1)) begin
                    ADD_HALF INSTF_HA_LAST (
                        .a(a[i]&b[j]),
                        .b(carries[i][j-1]),
                    
                        .sum(sums[i][j]),
                        .cout(carries[i][j])  
                    );
                end  
                
                //IN BETWEEN
                else begin
                    FULL_ADDER INSTF_FA (
                        .a(a[i]&b[j]),
                        .b(a[i-1]&b[j+1]),
                        .cin(carries[i][j-1]),
                                
                        .sum(sums[i][j]),
                        .cout(carries[i][j])       
                    );
                end
            end //FIRST LEVEL
            
            //LAST LEVEL OF PARTIAL SUMS
            else if(i==(bits-1)) begin
            
                //FIRST ADDER
                if(j==0) begin 
                    ADD_HALF INSTL_HA_FIRST (
                        .a(sums[i-1][j+1]),
                        .b(a[i]&b[j]),
                    
                        .sum(p[i+j]),
                        .cout(carries[i][j]) 
                    );                
                end
                
                //LAST ADDER
                else if(j==(bits-1)) begin
                    FULL_ADDER INSTL_FA_LAST (
                        .a(carries[i-1][j]),
                        .b(a[i]&b[j]),
                        .cin(carries[i][j-1]),
                    
                        .sum(p[i+j]),
                        .cout(p[i+j+1])
                    );
                end
                
                //IN BETWEEN
                else begin
                    FULL_ADDER INSTL_FA (
                        .a(sums[i-1][j+1]),
                        .b(a[i]&b[j]),
                        .cin(carries[i][j-1]),                  
                    
                        .sum(p[i+j]),
                        .cout(carries[i][j])
                    );                
                end
            end //LAST LEVEL
            
            //ALL LEVELS IN BETWEEN
            else begin
                
                //FIRST ADDER
                if(j==0) begin
                    ADD_HALF INSTB_HA_FIRST (
                        .a(sums[i-1][j+1]),
                        .b(a[i]&b[j]),
                        
                        .sum(p[i]),
                        .cout(carries[i][j])
                    );
                end
                
                //LAST ADDER
                else if(j==(bits-1)) begin
                    FULL_ADDER INSTB_FA_LAST (
                        .a(carries[i-1][j]),
                        .b(a[i]&b[j]),
                        .cin(carries[i][j-1]),
                        
                        .sum(sums[i][j]),                    
                        .cout(carries[i][j])
                    );
                end
                
                //IN BETWEEN
                else begin
                    FULL_ADDER INSTB_FA (
                        .a(sums[i-1][j+1]),
                        .b(a[i]&b[j]),
                        .cin(carries[i][j-1]),
                        
                        .sum(sums[i][j]),
                        .cout(carries[i][j])                        
                    );          
                end
            end //IN BETWEEN LEVELS
        end //ADDERS FOR LOOP        
    end //LEVELS FOR LOOP
endgenerate
endmodule