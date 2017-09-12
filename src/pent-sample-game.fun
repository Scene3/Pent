/**  pent-sample-game.fun
 *
 *   An example game of Pent for testing and demonstration.
 *
 *
 **/

site pent {

    

    pent_game sample_game {

        pent_game this_game [/]
        
        // create a game
        eval(this_game);

        // set up the game
        this_game.start;
        this_game.set_player("Isaac Newton", "newton", true);
        this_game.set_player("Gottfried Leibniz", "leibniz", false);
        this_game.set_a_picks_first(true);

        // choose teams
        for int id from 1 to 12 by 2 {
           this_game.add_piece_by_id(id, true);
           this_game.add_piece_by_id(id + 1, false);
        }

    
    
    
    }




}
