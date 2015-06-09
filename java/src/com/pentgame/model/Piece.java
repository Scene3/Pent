/*
 * Piece.java
 */

package com.pentgame.model;


public class Piece {
	
    /** The Bento representation of a pent piece:
     * 
     *     piece [=
     *         int id [?]
     *         name [?]
     *         classic_name [?]
     *         int value [?]
     *         
     *         int rotations [?]
     *         int chirality [?]
     *         int width [?]
     *         int height [?]
     *         
     *         /-- the pieces array contains all pieces in id order, starting from 1 --/
     *         dynamic int index_for_id(id) = (id - 1)
     * 
     *         pent_position[] protos = []        
     * 
     *         int num_positions = rotations * chirality * (9 - width) * (9 - height)
     *
     *         // the proto array includes rotations, so width and height alternate from
     *         // proto to proto.  The nominal width and height apply to the 0th and
     *         // subsequent even-numbered protos, while for odd-numbered protos the 
     *         // width and height are swapped.
     *   
     *         dynamic int width_for_proto(int n) = (n & 1 ? height : width)
     *         dynamic int height_for_proto(int n) = (n & 1 ? width : height)
     *          
     *         pent_position[] all_positions = compute_all_positions
     *         
     *         dynamic pent_position[] compute_all_positions = [
     *                     for pent_position p in protos and int ix from 0 [=
     *                         // do the first row and the first column in 
     *                         // each row separately to avoid a call
     * 
     *                         /---- row 0, col 0 ----/
     *                         p, 
     *                         
     *                         /---- row 0, cols 1-7 ----/
     *                         for int num_cols from 1 to (9 - width_for_proto(ix)) [=
     *                             shift_right(p, num_cols),
     *                         =],
     * 
     *                         /---- rows 1-7 ----/                                  
     *                         for int num_rows from 1 to (9 - height_for_proto(ix)) [=
     * 
     *                             /---- col 0 ----/
     *                             shift_down(p, num_rows),
     *                             
     *                             /---- cols 1-7 ----/
     *                             for int num_cols from 1 to (9 - width_for_proto(ix)) [=
     *                                 shift_down_right(p, num_cols, num_rows),
     *                             =]
     *                         =]
     *                     =]
     *                 ]
     * 
     *         this;                                      
     *     =]
	 * 
	 */

    
    public int id;
    public String name;
    public String classic_name;
    public int value;
    public int rotations;
    public int chirality;
    public int width;
    public int height;
    public byte[][] protos;
    
    // computed fields
    public int num_positions;
    public byte[][] all_positions;
    
    public Piece(int id, 
                 String name,
                 String classic_name,
                 int value,
                 int rotations,
                 int chirality,
                 int width,
                 int height,
                 byte[][] protos) {

        this.id = id;
        this.name = name;
        this.classic_name = classic_name;
        this.value = value;
        this.rotations = rotations;
        this.chirality = chirality;
        this.width = width;
        this.height = height;
        this.protos = protos;
        
        num_positions = computeNumPositions();
        all_positions = computeAllPositions();
    }

    private int computeNumPositions() {
        int numPositions = rotations * chirality * (9 - width) * (9 - height);
        return numPositions;
    }
    
    
    private byte[][] computeAllPositions() {
        byte[][] allPositions = new byte[8][num_positions];
        
        return allPositions;
    }


    private byte[] shiftDown(byte[] pp, int numRows) {
        byte[] newPos = new byte[8];
        
        for (int i = 0; i < 8; i++) {
            newPos[i] = pp[ (i + 8 - numRows)  & 7 ];
        }
        return newPos;    
    }

    private byte[] shiftRight(byte[] pp, int numCols) {
        byte[] newPos = new byte[8];
        
        for (int i = 0; i < 8; i++) {
            newPos[i] = (byte) (pp[i] >> numCols);
        }
        return newPos;    
    }

    private byte[] shiftDownRight(byte[] pp, int numCols, int numRows) {
        byte[] newPos = new byte[8];
        
        for (int i = 0; i < 8; i++) {
            newPos[i] = (byte) (pp[ (i + 8 - numRows)  & 7 ] >> numCols);
        }
        return newPos;    
    }
}
