.data


.balign 8

zero:   .double 0
four:   .double 4
negative:   .double -1
two:    .double 2

.text

.global ship

//
// int ship(double xn0, double yn0)
// @author Yogesh Prabhu

ship:
    stp x29, x30, [sp, #-16]!
    
    ldr x0, =zero
    ldr d2,[x0]   // x = 0

    ldr x0, =zero
    ldr d3,[x0]   // y = 0

    mov w4, #0    // int iteration = 0

loop_start:

    fmul d5, d2, d2 // x*x
    fmul d6, d3, d3 // y*y

    fadd d5, d5, d6 // x*x + y*y
    
    ldr x0, =four
    ldr d7, [x0]

    fcmp d5, d7   // is x*x + y*y < 4?
    blt second_check //if yes go to second check
    
    b ship_done // else end loop
    
while_loop:
    
    ldr x0, =zero
    ldr d7, [x0]

    
    // x = x >= 0 ? x : -x;
    fcmp d2, d7  // |x|
    blt positive_x

    // y = y >= 0 ? y : -y;
    fcmp d3, d7   // |y|
    blt positive_y

    // double xn1 = x*x - y*y + xn0;

    fmul d5, d2, d2
    fmul d6, d3, d3
    fsub d5, d5, d6 
    fadd d5, d5, d0
    
    // double yn1 = 2*x*y + yn0;
    fmul d6, d2, d3
    
    ldr x0, =two
    ldr d7, [x0] 

    fmul d6, d6, d7
    fadd d6, d6, d1


    fmov d2, d5 // x = xn1
    fmov d3, d6 // y = yn1

    add w4, w4, #1 // iteration++;

    b loop_start

positive_x:
    ldr x0, =negative
    ldr d7, [x0]
    
    fmul d2, d2, d7  // x = x*-1

    b while_loop

positive_y:
    ldr x0, =negative
    ldr d7, [x0]

    fmul d3, d3, d7  // y = y*-1

    b while_loop
    
second_check:
    cmp w4, #255    // is iteration < 255?
    blt while_loop  //if yes then continue to loop
    
    b ship_done // else end loop

ship_done:
    mov w0, w4
    ldp x29, x30, [sp], #16
    ret             // return 
