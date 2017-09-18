/**  pent-tests.fun
 *
 *   Tests for Pent.
 *
 **/

site pent {

    test_runner[] test_runners = [ pent_model_tests,
                                   pent_game_tests
                                 ]
    

    public page(*) tests(params{}) {
        boolean needs_login = false
        boolean needs_admin = false    
        boolean show_menu = false

        label = "Tests"
    
        [| <h2>Test Results</h2> |]

        /--- run all the tests in the test runner list ---/
        for test_runner tr in test_runners {                
        
            [| <strong>{= tr.name; =}<strong><ol> |]
            
            tr.run;
        
            for test_result rslt in tr.results {
                [| <li>{= rslt.name; =}<br> |]
                if (rslt.result) [|
                    Passed
                |] else [|
                    <span style="color:red">Failed</span>
                |]
                [| <br><ul> |]
                for msg in rslt.messages [|
                    <li>{= msg; =}</li>
                |]
                [| </ul></li> |]                
            }
            [| </ol> |]
        }
    }

test_runner test_tests {
 test_base test_test {
     expected = "!"
     
     "!";
     test_log("Ok, ok.");       
 }
}


    test_runner pent_model_tests {
    
        test_base test_pieces {
            expected = "ABC"
            
            int num_problems(int n) = n
            
            for piece p in pieces {
                log("first piece loop: " + p.name);
                if (p.protos.count != p.rotations * p.chirality) {
                    eval(num_problems(: num_problems + 1 :));
                }
            }
            
            if (!num_problems) {
                test_log("all pieces have correct number of protos");
                "A";
            } else {
                if (num_problems == 1) {
                    test_log("one piece has incorrect number of protos");
                } else {
                    test_log(num_problems + " pieces have incorrect number of protos");
                }
                eval(num_problems(: 0 :));
            }

            for piece p in pieces {
                log("second piece loop: " + p.name);
                if (p.all_positions.count != p.num_positions) {
                    test_log("piece " + p.id + " num positions should be " + p.num_positions + " but is " + p.all_positions.count);
                    eval(num_problems(: num_problems + 1 :));
                }
            }
                
            if (!num_problems) {
                test_log("all pieces have correct number of positions");
                "B";
            } else {
                if (num_problems == 1) {
                    test_log("one piece has incorrect number of positions");
                } else {
                    test_log(num_problems + " pieces have incorrect number of positions");
                }
                eval(num_problems(: 0 :));
            }
            
            pent_position pos_accumulator(pent_position pos) = pos
            pent_position full_plus = [ #7E, #FF, #FF, #FF, #FF, #FF, #FF, #7E ]
            pent_position empty_position = [ 0, 0, 0, 0, 0, 0, 0, 0 ]
            pent_position full_position = [ #FF, #FF, #FF, #FF, #FF, #FF, #FF, #FF ]
            
            for piece p in pieces {
                log("testing piece " + p.id);
                eval(pos_accumulator(: empty_position :));
                for pent_position pos in p.all_positions {
                    eval(pos_accumulator(: pos_accumulator | pos :));
                }
                
                if (p.id != PLUS_ID) {
                    if (pos_accumulator != full_position) {
                        test_log("all_positions incorrect for piece " + id);
                        eval(num_problems(: num_problems + 1 :));
                    }
                } else {
                    if (pos_accumulator != full_plus) {
                        test_log("all_positions incorrect for plus");
                        eval(num_problems(: num_problems + 1 :));
                    }
                }
            
            }
            if (!num_problems) {
                test_log("all pieces have correct all_positions");
                "C";
                eval(num_problems(: 0 :));
            }
            
        }
        
        test_base, pent_board test_board_stateless_testers {
            expected = "ABCDEF"
        
            // empty board
            pent_position z = [ 0, 0, 0, 0, 0, 0, 0, 0 ]
        
            // three squares.  a and b overlap, so do b and c.  a and c do not
            
            pent_position a = [ #C0, #C0, 0, 0, 0, 0, 0, 0 ]
            pent_position b = [ 0, #60, #60, 0, 0, 0, 0, 0 ]
            pent_position c = [ #30, #30, 0, 0, 0, 0, 0, 0 ]

            // test is_empty
            if (is_empty(z)) {
                "A";
                test_log("is_empty works on empty position");
            } else {
                test_log("is_empty failed on empty position");
            }
            if (!is_empty(a) && !is_empty(b) && !is_empty(c)) {
                "B";
                test_log("is_empty works on non-empty position");
            } else {
                test_log("is_empty failed on non-empty position");
            }
            
            // test is_hit
            if (is_hit(a, b) && is_hit(b, c)) {
                "C";
                test_log("is_hit detects overlap");
            } else {
                test_log("is_hit failed to detect hit with overlapping positions");
            }
            if (is_hit(a, a) && is_hit(b, b) && is_hit(c, c)) {
                "D";
                test_log("is_hit detects hit with self");
            } else {
                test_log("is_hit failed to detect hit with self");
            }
            if (!is_hit(a, z) && !is_hit(b, z) && !is_hit(c, z) && !is_hit(z, z)) {
                "E";
                test_log("is_hit works (returns false) with empty position");
            } else {
                test_log("is_hit detected impossible hit (on empty)");
            }
            if (!is_hit(a, c)) {
                "F";
                test_log("is_hit works (returns false) on non-overlapping positions");
            } else {
                test_log("is_hit detected nonexistent hit (positions do not overlap)");
            }
        }
        
        test_base test_cell_mask_converters {
            expected = "ABCD"
        
            pent_position empty_mask = [ 0, 0, 0, 0, 0, 0, 0, 0 ]
            pent_position full_mask = [ #FF, #FF, #FF, #FF, #FF, #FF, #FF, #FF ]
            pent_position horizontal_half_mask = [ #FF, #FF, #FF, #FF, 0, 0, 0, 0 ]
            pent_position vertical_half_mask = [ #F0, #F0, #F0, #F0, #F0, #F0, #F0, #F0 ]


            // empty cells to mask
            pent_board empty_cells_board {
                keep: int[] cells = [ for int i from 0 to 64 { 0 } ]
            }

            if (empty_cells_board.mask == empty_mask) {
                "A";
                test_log("empty cells correctly converted to mask");
             } else {
                test_log("empty cells incorrectly converted to mask: " + empty_cells_board.mask);
             }
            
            // full cells to mask
            pent_board full_cells_board {
                keep: int[] cells = [ for int i from 0 to 64 { (i % 12 + 1) } ]
            }

            if (full_cells_board.mask == full_mask) {
                "B";
                test_log("full cells correctly converted to mask");
             } else {
                test_log("full cells incorrectly converted to mask: " + full_cells_board.mask);
             }
            
            // partial cells to mask
            pent_board horizontal_half_cells_board {
                keep: int[] cells = [ for int i from 0 to 32 { (12 - (i % 12)) },
                                      for int i from 0 to 32 { 0 } ]
            }

            pent_board vertical_half_cells_board {
                keep: int[] cells = [ for int i from 0 to 64 { 
                                          if (i % 8 < 4) { (i + 1) }
                                          else { 0 }
                                      } ]
            }

            if (horizontal_half_cells_board.mask == horizontal_half_mask) {
                "C";
                test_log("horizontal half cells correctly converted to mask");
            } else {
                log("horizontal half cells count: " + horizontal_half_cells_board.cells.count);
                log("  ...cell[63]: " + horizontal_half_cells_board.cells[63]);
                test_log("horizontal half cells incorrectly converted to mask: " + (string) horizontal_half_cells_board.mask);
            }            
            
            if (vertical_half_cells_board.mask == vertical_half_mask) {
                "D";
                test_log("vertical half cells correctly converted to mask");
            } else {
                test_log("vertical half cells incorrectly converted to mask: " + vertical_half_cells_board.mask);
            }            
        }


        test_base test_board_stateful_testers {
            expected = "ABC"
        
            // empty board
            pent_board empty_board {
                keep: pent_position mask = empty_board_mask
            }
            
            // modified boards
            pent_board board_with_no_openings {
                keep: int[] cells = [ for int i from 0 to 60 { 7 }, 0, 0, 0, 0 ]
            }
            
            pent_board board_with_24_openings {
                keep: int[] cells = [ for int i from 0 to 52 { 7 },
                                      0, 0, 0, 0, 9, 9, 9, 9, 0, 0, 0, 0 ]
            }

            int num_positions(int n) = n
            
            /--- use expression comprehension to sum num_positions across all pieces ---/
            int total_positions = pieces[0].num_positions + for int i from 1 to 12 { pieces[i].num_positions }

            log("total positions: " + total_positions);
            
            // empty board: every position should be open
            log("computing positions for empty board...");
            eval(num_positions(: 0 :));

            for piece p in pieces {
                for pent_position pos in p.all_positions {
                    if (empty_board.is_open(pos)) {
                        eval(num_positions(: num_positions + 1 :));
                    }
                }
            }
            
            if (num_positions == total_positions) {
                "A";
                test_log("correct number of open positions on empty board");
            
            } else {
                test_log("incorrect number of open positions on empty board: " + num_positions);
            }

            
            // board with 60 out of 64 cells full: no position should be open
            log("computing positions for board with 4 squares open...");
            eval(num_positions(: 0 :));
            for piece p in pieces {
                for pent_position pos in p.all_positions {
                    if (board_with_no_openings.is_open(pos)) {
                        eval(num_positions(: num_positions + 1 :));
                    }
                }
            }
            
            if (num_positions == 0) {
                "B";
                test_log("correct number of open positions on board with only four squares open");
            
            } else {
                test_log("incorrect number of open positions on board with only four squares open: " + num_positions);
            }
            
            
            // board with 2 X 4 opening: 24 positions should be open
            // (8 for utah, 4 each for snake, pipe, long_L and C_piece)
            log("computing positions for board with 2 X 4 opening...");
            eval(num_positions(: 0 :));
            for piece p in pieces {
                for pent_position pos in p.all_positions {
                    if (board_with_24_openings.is_open(pos)) {
                        eval(num_positions(: num_positions + 1 :));
                    }
                }
            }
            
            if (num_positions == 24) {
                "C";
                test_log("correct number of open positions on board with 2 X 4 opening");
            
            } else {
                test_log("incorrect number of open positions on board with 2 X 4 opening: " + num_positions);
            }    
        }


        test_base, pent_board test_plays {
            expected = "ABCDEF"
            
            play p1 = play(utah, 0)
            pent_position pp1 = [ #80, #C0, #C0, 0, 0, 0, 0, 0 ]
            
            if (p1.piece.name == "Utah") {
                "A";
                test_log("first play has correct piece");
            } else {
                test_log("first play has wrong piece");
            }
            
            if (p1.position == pp1) {
                "B";
                test_log("first play has correct position");
            } else {
                test_log("first play has wrong position");
            }
              
            play p2 = play(bar, 63)
            pent_position pp2 = [ 0, 0, 0, 0, 0, 0, 0, #1F ]
        
            if (p2.piece.id == 11) {
                "C";
                test_log("second play has correct piece");
            } else {
                test_log("second play has wrong piece");
            }
            
            if (p2.position == pp2) {
                "D";
                test_log("second play has correct position");
            } else {
                test_log("second play has wrong position: " + (string) p2.position);
            }
            
            // test the logic that sets cell values correctly according to an 
            // array of plays. First we test a single play on two cells, one which
            // intersects and one which doesn't. 
            
            play[] p1_array = [ p1 ]
            if (plays_to_cell(p1_array, 0) == p1.piece.id) {
                "E";
                test_log("cell 0 (a hit) correctly initialized by first play");
            } else {
                test_log("cell 0 not initialized correctly by first play");
            }
            
            if (plays_to_cell(p1_array, 1) == 0) {
                "F";
                test_log("cell 1 (a miss) correctly initialized by first play");
            } else {
                test_log("cell 0 not initialized correctly by first play");
            }
        }

    }

emptyclass [/]

emptyclass, pent_board p2c {
  play p1 = play(utah, 0)
  play[] p1_array = [ p1 ]
  plays_to_cell(p1_array, 0);
}

pgt {
  this pent_game [/]
        
  eval(pent_game);
  pent_game.set_a_picks_first(true);
}

        
        
    test_runner pent_game_tests {

        test_base test_pent_game_start {
            expected = "ABCD"
            
            this pent_game [/]
            
            {
                eval(pent_game);
                "A";
                test_log("pent_game correctly starts without redirection");

            } catch {
                test_log("pent_game incorrectly redirects on call to start");
            }
            
            
            // when first started, a pent_game enters the CHOOSE_PLAYERS phase
            if (pent_game.phase == CHOOSE_PLAYERS) {
                "B";
                test_log("pent_game in correct phase after call to start");
            } else {
                test_log("pent_game in wrong phase after call to start: " + pent_game.phase);
            }
            
            
            // functions that are meaningful only in other phases should redirect
            // to an illegal_action_for_phase error
            {
                pent_game.set_a_picks_first(true);
                test_log("pent_game incorrectly allows call to set_a_picks_first");

            } catch illegal_action_for_phase {
                "C";
                test_log("pent_game correctly redirects on call to set_a_picks_first");
            } catch {
                test_log("pent_game throws wrong kind of redirect on call to set_a_picks_first");
            }

            {
                pent_game.add_piece_by_id(1, true);
                test_log("pent_game incorrectly allows call to add_piece_by_id");

            } catch illegal_action_for_phase {
                "D";
                test_log("pent_game correctly redirects on call to add_piece_by_id");
            } catch {
                test_log("pent_game throws wrong kind of redirect on call to add_piece_by_id");
            }
        }

    
        test_base test_pent_game_choose_players {
            expected = "ABCDEFGH"
            
            this pent_game [/]
            
            eval(pent_game);
            
            // when first started, a pent_game enters the CHOOSE_PLAYERS phase
            if (pent_game.phase == CHOOSE_PLAYERS) {
                "A";
                test_log("pent_game correctly in CHOOSE_PLAYERS phase upon starting");
            } else {
                test_log("pent_game not in CHOOSE_PLAYERS state after call to start");
            }
            
            
            // functions that are meaningful only in other phases should redirect
            {
                pent_game.set_a_picks_first(true);
                test_log("pent_game incorrectly allows call to set_a_picks_first");

            } catch illegal_action_for_phase {
                "B";
                test_log("pent_game correctly redirects on call to set_a_picks_first");
            } catch {
                test_log("pent_game throws wrong kind of redirect on call to set_a_picks_first");
            }

            {
                pent_game.add_piece_by_id(1, true);
                test_log("pent_game incorrectly allows call to add_piece_by_id");

            } catch illegal_action_for_phase {
                "C";
                test_log("pent_game correctly redirects on call to add_piece_by_id");
            } catch {
                test_log("pent_game throws wrong kind of redirect on call to add_piece_by_id");
            }
           
            // now choose players.  To start with, neither player should have a value.
            if (!pent_game.player_A && !pent_game.player_B) {
                "D";
                test_log("CHOOSE_PLAYERS phase correctly begins with neither player set");
            } else {
                test_log("CHOOSE_PLAYERS phase incorrectly begins with one or both players set");
            }

            // After choosing one player, the game should still be in the CHOOSE_PLAYERS
            // phase.  After choosing two players, the game should advance to the CHOOSE_ORDER phase. 
            {
                pent_game.set_player("Al Pha", "a", true);
                if (pent_game.player_A && pent_game.player_A.name == "Al Pha" && pent_game.player_A.id == "a") {
                    "E";
                    test_log("player A chosen successfully");
                } else if (!pent_game.player_A) {
                    test_log("player A has no value after being chosen");
                } else if (pent_game.player_A.name != "Al Pha") {
                    test_log("player A has wrong name after being chosen");
                } else {                    
                    test_log("player A has wrong id after being chosen");
                }                    
                

                if (!pent_game.player_B) {
                    "F";
                    test_log("player B correctly has no value after only Player A has been chosen");
                } else {
                    test_log("player B incorrectly has a value after Player A is chosen");
                }
            
                pent_game.set_player("B Eta", "b", false);
                if (pent_game.player_A && pent_game.player_B && pent_game.player_B.name == "B Eta" && pent_game.player_B.id == "b") {
                    "G";
                    test_log("both players chosen successfully");
                } else if (!pent_game.player_B) {
                    test_log("unable to choose player B");
                } else if (pent_game.player_B.name != "B Eta") {
                    test_log("player B has wrong name after being chosen (" + pent_game.player_B.name + " instead of B Eta)");
                } else if (pent_game.player_B.id != "b") {                    
                    test_log("player B has wrong id after being chosen");
                } else {
                    test_log("player A is null after Player B is chosen");
                }
                
            } catch illegal_action_for_phase {
                test_log("unable to choose player, got an illegal_action_for_phase redirection");
            } catch {
                test_log("unable to choose player, unknown redirection");
            }
                    
            if (pent_game.phase == CHOOSE_ORDER) {
                "H";
                test_log("pent_game phase correctly advanced to CHOOSE_ORDER after both players were chosen");
            } else {
                test_log("pent_game in wrong phase after choosing both players: " + pent_game.phase);
            }
       }

        test_base test_pent_game_choose_order {
            expected = "ABCDEF"
            
            pent_game pent_game_1 [/]

            eval(pent_game_1);
            {
                pent_game_1.set_player("Al Pha", "a", true);
                pent_game_1.set_player("B Eta", "b", false);
                "A";
                test_log("successfully started game and set players");

            } catch {
                test_log("failed to start game and set players");
            }
            
            if (pent_game_1.phase == CHOOSE_ORDER) {
                "B";
                test_log("pent_game successfully reaches CHOOSE_ORDER phase");
            } else {
                test_log("pent_game fails to reach CHOOSE_ORDER phase");
            }

            // functions that are meaningful only in other phases should redirect
            // to an illegal_action_for_phase error
            {
                pent_game_1.add_piece_by_id(1, true);
                test_log("pent_game incorrectly allows call to add_piece_by_id");

            } catch illegal_action_for_phase {
                "C";
                test_log("pent_game correctly redirects on call to add_piece_by_id");
            } catch {
                test_log("pent_game throws wrong kind of redirect on call to add_piece_by_id");
            }

            
            {
                pent_game_1.set_a_picks_first(true);
                if (pent_game_1.a_picks_first) {
                    "D";
                    test_log("correctly chose player A to pick first");
                } else {
                    test_log("failed to choose player A to pick first");
                }
            } catch illegal_action_for_phase {
                test_log("pent_game incorrectly redirects on call to set_a_picks_first");
            } catch {
                test_log("pent_game throws wrong kind of redirect on call to set_a_picks_first");
            }

            // to test choosing the other way, start another game.
            pent_game pent_game_2 [/]

            eval(pent_game_2);                    
            pent_game_2.set_player("Abe", "a", true);
            pent_game_2.set_player("Babe", "b", false);

            {                

                pent_game_2.set_a_picks_first(false);
                if (!pent_game_2.a_picks_first) {
                    "E";
                    test_log("in second pent_game, correctly chose player B to pick first");
                } else {
                    test_log("in second pent_game, failed to choose player B to pick first");
                }

            } catch {
                test_log("pent_game incorrectly redirects on second call to set_a_picks_first");
            }

            if (pent_game_1.phase == CHOOSE_TEAM && pent_game_2.phase == CHOOSE_TEAM) {
                "F";
                test_log("pent_game phase correctly advanced to CHOOSE_TEAM after player order was chosen");
            } else {
                test_log("pent_game in wrong phase after choosing player order: " + pent_game.phase);
            }
        }

        test_base test_pent_game_choose_team {
            expected = "ABCDEFGHIJ"
            
            this pent_game [/]

            eval(pent_game);
            {
                pent_game.set_player("Al Pha", "a", true);
                pent_game.set_player("B Eta", "b", false);
                pent_game.set_a_picks_first(true);
                "A";
                test_log("successfully started game, set players and chose order");

            } catch {
                test_log("failed to start game, set players and choose order");
            }
            
            if (pent_game.phase == CHOOSE_TEAM) {
                "B";
                test_log("pent_game successfully reaches CHOOSE_TEAM phase");
            } else {
                test_log("pent_game fails to reach CHOOSE_TEAM phase");
            }

            // functions that are meaningful only in other phases should redirect
            // to an illegal_action_for_phase error
            {
                pent_game.set_player("Horton", "hoo", true);
                test_log("pent_game incorrectly allows call to set_player after players already chosen");

            } catch illegal_action_for_phase {
                "C";
                test_log("pent_game correctly redirects on call to set_player");
            } catch {
                test_log("pent_game throws wrong kind of redirect on call to set_player");
            }

            {
                pent_game.set_a_picks_first(true);
                test_log("pent_game incorrectly allows call to set_a_picks_first");

            } catch illegal_action_for_phase {
                "D";
                test_log("pent_game correctly redirects on call to set_a_picks_first");
            } catch {
                test_log("pent_game throws wrong kind of redirect on call to set_a_picks_first");
            }

            {
                pent_game.add_piece_by_id(1, true);
                "E";
                test_log("pent_game correctly allows adding first piece");

            } catch illegal_action_for_phase {
                test_log("pent_game incorrectly redirects on call to add_piece_by_id");
            } catch {
                test_log("pent_game throws wrong kind of redirect on call to add_piece_by_id");
            }

            {
                pent_game.add_piece_by_id(1, false);
                test_log("pent_game incorrectly allows adding the same piece twice");

            } catch unable_to_add_piece {
                "F";
                test_log("pent_game correctly redirects when adding the same piece twice");
            } catch {
                test_log("pent_game throws wrong kind of redirect when adding the same piece twice");
            }

            {
                pent_game.add_piece_by_id(2, false);
                pent_game.add_piece_by_id(3, true);
                pent_game.add_piece_by_id(4, false);
                pent_game.add_piece_by_id(5, true);
                pent_game.add_piece_by_id(6, false);
                pent_game.add_piece_by_id(7, true);
                pent_game.add_piece_by_id(8, false);
                pent_game.add_piece_by_id(9, true);
                pent_game.add_piece_by_id(10, false);
                pent_game.add_piece_by_id(11, true);
                if (pent_game.team_A.count == 6) {
                    "G";
                    test_log("team A chosen correctly");
                } else {
                    test_log("incorrect number of pieces on team A: " + pent_game.team_A.count);
                }
                
            } catch {
                test_log("pent_game incorrectly redirects when adding a valid piece");
            }

            {
                pent_game.add_piece_by_id(12, true);
                test_log("pent_game incorrectly allows adding a seventh piece to team A");

            } catch unable_to_add_piece {
                "H";
                test_log("pent_game correctly redirects when attempting to add a seventh piece");
            } catch {
                test_log("pent_game throws wrong kind of redirection when attempting to add a seventh piece");
            }

            {
                pent_game.add_piece_by_id(12, false);
                if (pent_game.team_B.count == 6) {
                    "I";
                    test_log("team B chosen correctly");
                } else {
                    test_log("incorrect number of pieces on team B: " + pent_game.team_B.count);
                }

            } catch {
                test_log("pent_game incorrectly redirects when adding a valid piece");
            }
            
            if (pent_game.phase == PLAY_GAME) {
                "J";
                test_log("pent_game phase correctly advances to PLAY_GAME after both teams are chosen");
            } else {
                test_log("pent_game in wrong phase after choosing both teams: " + pent_game.phase);
            }
        }            

        test_base test_pent_game_play_game {
            expected = "ABCDEF"
            
            this pent_game [/]

            eval(pent_game);
            {
                pent_game.set_player("Al Pha", "a", true);
                pent_game.set_player("B Eta", "b", false);
                pent_game.set_a_picks_first(true);

                for int id from 1 to 12 by 2 {
                    pent_game.add_piece_by_id(id, true);
                    pent_game.add_piece_by_id(id + 1, false);
                }

                "A";
                test_log("successfully started game, set players, chose order and chose teams");

            } catch {
                test_log("failed to start game, set players, choose order and choose teams");
            }

            if (pent_game.phase == PLAY_GAME) {
                "B";
                test_log("pent_game successfully reaches PLAY_GAME phase");
            } else {
                test_log("pent_game fails to reach PLAY_GAME phase");
            }

            // it should be the first turn
            if (pent_game.turn == 1) {
                "C";
                test_log("game starts at turn 1");
            } else {
                test_log("game should start at turn 1 but instead starts at turn " + turn);
            }
            
            // player A picked first, so player B should go first
            if (!pent_game.a_goes_next) {
                "D";
                test_log("it is correctly player B's turn");
            } else {
                test_log("it should be player B's turn but it's player A's turn");
            }
            
            // player B goes first, so all pieces on team_B should be available
            if (pent_game.is_available(pent_game.team_B[0]) &&
                pent_game.is_available(pent_game.team_B[1]) &&
                pent_game.is_available(pent_game.team_B[2]) &&
                pent_game.is_available(pent_game.team_B[3]) &&
                pent_game.is_available(pent_game.team_B[4]) &&
                pent_game.is_available(pent_game.team_B[5])) {
                "E";
                test_log("all of player B's pieces are correctly available to play");
            } else {
                test_log("not all of player B's pieces are available");
            }
            
            // player B goes first, so none of the pieces on team_A should be available
            if (!pent_game.is_available(pent_game.team_A[0]) &&
                !pent_game.is_available(pent_game.team_A[1]) &&
                !pent_game.is_available(pent_game.team_A[2]) &&
                !pent_game.is_available(pent_game.team_A[3]) &&
                !pent_game.is_available(pent_game.team_A[4]) &&
                !pent_game.is_available(pent_game.team_A[5])) {
                "F";
                test_log("all of player A's pieces are correctly unavailable to play");
            } else {
                test_log("some of player A's pieces are incorrectly available");
            }
        }
    }

    /------ informal tests ------/

    public show_all_positions(params{}) {
    
        int ix = params["piece"] ? (int) params["piece"] : 0
        piece p = pieces[ix]
       
        p.name;
        br; br; 
        p.all_positions.count;
        [/ positions: |]
        [| <ol> |]
        
        for pent_position pos in pieces[ix].all_positions {
            [| <li> |]
            pos;
            [| </li> |]
        }
        [| </ol> |]
    }
    
    show_pos_count {
        for piece p in pieces {
            log("checking " + p.name);
            if (p.all_positions.count == p.num_positions) {
                p.name;
                " is good<br>";
            }
        }
    }
    
    show_a_pos {
        utah.all_positions[0];
    }
    
    show_all_utah_pos {
        for pent_position p in utah.all_positions {
            p;
            br;
        }
    }
    
    show_num_pos {
        for piece p in pieces {
            "id: ";
            p.id;
            "   num positions: ";
            p.num_positions;
            br;
        }
    }

          
            
}
