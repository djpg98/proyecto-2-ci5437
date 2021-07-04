// Game of Othello -- Example of main
// Universidad Simon Bolivar, 2012.
// Author: Blai Bonet
// Last Revision: 1/11/16
// Modified by: Diego Peña, 15-11095

#define NEGAINFINITY -40
#define LE 1
#define LEQ -1 

#include <iostream>
#include <limits>
#include "othello_cut.h" // won't work correctly until .h is fixed!
#include "utils.h"
#include <unordered_map>
#include <algorithm>
#include <signal.h>
#include <unistd.h>
#define INFINITY 100000

using namespace std;
unsigned expanded = 0;
unsigned generated = 0;
int tt_threshold = 32; // threshold to save entries in TT
bool first = true;

void sigalrm_handler(int sig){

    exit(EXIT_SUCCESS);
}


// Transposition table (it is not necessary to implement TT)
struct stored_info_t {
    int value_;
    int type_;
    enum { EXACT, LOWER, UPPER };
    stored_info_t(int value = -100, int type = LOWER) : value_(value), type_(type) { }
};

struct hash_function_t {
    size_t operator()(const state_t &state) const {
        return state.hash();
    }
};

class hash_table_t : public unordered_map<state_t, stored_info_t, hash_function_t> {
};

hash_table_t TTable[2];

bool test_your_might(state_t state, int depth, int color, int score, int condition){
    state_t child;
    vector<int> valid_moves;
    bool color_b;
    if (depth == 0 || state.terminal()){
        if (condition == LE){
            return (color * state.value()) < score ? true : false;
        } else {
            return (color * state.value()) <= score ? true : false;
        }
    }

    color_b = (color == 1) ? true : false;
    state.get_valid_moves(valid_moves, color_b);
    while(!valid_moves.empty()){
        child = state.move(color_b, valid_moves.back());
        valid_moves.pop_back();
        if (test_your_might(child, depth - 1, -color, -score, -condition)){
            return (condition == LE) ? false : true;
        }
    }    

    return (condition == LE) ? true : false;
}

//int maxmin(state_t state, int depth, bool use_tt);
//int minmax(state_t state, int depth, bool use_tt = false);
//int maxmin(state_t state, int depth, bool use_tt = false);

int scout(state_t state, int depth, int color, bool use_tt = false){
    state_t child;
    vector<int> valid_moves;
    int score;
    bool first_child, color_b;
    if (depth == 0 || state.terminal()){
        return color * state.value();
    }

    score = color * state.value(); //Esto podría ser un punto de error, pendiente en el futuro
    first_child = true;
    color_b = (color == 1) ? true : false;
    state.get_valid_moves(valid_moves, color_b);
    while(!valid_moves.empty()){ 
        child = state.move(color_b, valid_moves.back());
        valid_moves.pop_back();
        if (first_child){
            score = -scout(child, depth - 1, -color, use_tt);
            first_child = false;
        } else {
            if (test_your_might(child, depth - 1, -color, -score, LE)){
                score = -scout(child, depth - 1, -color, use_tt);
            }
        }
    }

    return score;

}

int negascout(state_t state, int depth, int alpha, int beta, int color, bool use_tt = false){
    state_t child;
    vector<int> valid_moves;
    int score, prueba;
    bool first_child, color_b;

    if (depth == 0 || state.terminal()){
        return color * state.value();
    }

    first_child = true;
    color_b = (color == 1) ? true : false;
    state.get_valid_moves(valid_moves, color_b);
    while(!valid_moves.empty()){ 
        child = state.move(color_b, valid_moves.back());
        valid_moves.pop_back();
        if (first_child){
            score = -negascout(child, depth - 1, -beta, -alpha, -color);
            first_child = false;
        } else {
            score = -negascout(child, depth - 1, -alpha - 1, -alpha, -color);

            if ((alpha < score) && (score < beta)){
                score = -negascout(child, depth -1, -beta, -score, -color);
            }
        }

        alpha = max(alpha, score);

        if (alpha >= beta){
            break;
        }
    }

    return alpha;
}


int negamax(state_t state, int depth, int color, bool use_tt = false){

    if (depth == 0 || state.terminal()) {
        return color * state.value();
    }
    if (first) {
        generated = 1;
        first = false;
    }

    expanded += 1;
    int alpha = -INFINITY;
    vector<int> valid_moves;
    state.get_valid_moves(valid_moves, color);
    generated += valid_moves.size();

    state_t child;
    while (!valid_moves.empty()) {

        if (color == 1) {
            child = state.black_move(valid_moves.back());
        }
        else {
            child = state.white_move(valid_moves.back());
        }
        valid_moves.pop_back();
        
        alpha = max(alpha, -negamax(child, depth - 1, -color));

    }

    return alpha;
}


int negamax(state_t state, int depth, int alpha, int beta, int color, bool use_tt = false) {
    
    if (depth == 0 || state.terminal()) {
        return color * state.value();
    }
    if (first) {
        generated = 1;
        first = false;
    }

    expanded += 1;
    int score = -INFINITY;
    vector<int> valid_moves;
    state.get_valid_moves(valid_moves, color);
    generated += valid_moves.size();

    state_t child;
    int val;
    while (!valid_moves.empty()) {

        if (color == 1) {
            child = state.black_move(valid_moves.back());
        }
        else {
            child = state.white_move(valid_moves.back());
        }
        valid_moves.pop_back();

        val = negamax(child, depth - 1, -beta, -alpha, -color);
        score = max(score, val);
        alpha = max(alpha, val);

        if (alpha >= beta) break;
    }

    return score;
}


int main(int argc, const char **argv) {
    state_t pv[128];
    int npv = 0;
    for( int i = 0; PV[i] != -1; ++i ) ++npv;
    signal(SIGALRM, &sigalrm_handler);

    int algorithm = 0;
    if( argc > 1 ) algorithm = atoi(argv[1]);
    bool use_tt = argc > 2;

    // Extract principal variation of the game
    state_t state;
    cout << "Extracting principal variation (PV) with " << npv << " plays ... " << flush;
    for( int i = 0; PV[i] != -1; ++i ) {
        bool player = i % 2 == 0; // black moves first!
        int pos = PV[i];
        pv[npv - i] = state;
        state = state.move(player, pos);
    }
    pv[0] = state;
    cout << "done!" << endl;

#if 0
    // print principal variation
    for( int i = 0; i <= npv; ++i )
        cout << pv[npv - i];
#endif

    // Print name of algorithm
    cout << "Algorithm: ";
    if( algorithm == 1 )
        cout << "Negamax (minmax version)";
    else if( algorithm == 2 )
        cout << "Negamax (alpha-beta version)";
    else if( algorithm == 3 )
        cout << "Scout";
    else if( algorithm == 4 )
        cout << "Negascout";
    cout << (use_tt ? " w/ transposition table" : "") << endl;

    // Run algorithm along PV (bacwards)
    cout << "Moving along PV:" << endl;
    for( int i = 3; i <= 3; ++i ) {
        //cout << pv[i];
        alarm(0);
        int value = 0;
        TTable[0].clear();
        TTable[1].clear();
        float start_time = Utils::read_time_in_seconds();
        expanded = 0;
        generated = 0;
        first = true;
        int color = i % 2 == 1 ? 1 : -1;

        try {
            if( algorithm == 1 ) {
                value = negamax(pv[i], 50, color, use_tt);
            } else if( algorithm == 2 ) {
                value = negamax(pv[i], 50, -INFINITY, INFINITY, color, use_tt);
            } else if( algorithm == 3 ) {
                alarm(900);
                value = scout(pv[i], 70, color, use_tt);
            } else if( algorithm == 4 ) {
                alarm(900);
                value = negascout(pv[i], 70, -200, 200, color, use_tt);
            }
        } catch( const bad_alloc &e ) {
            cout << "size TT[0]: size=" << TTable[0].size() << ", #buckets=" << TTable[0].bucket_count() << endl;
            cout << "size TT[1]: size=" << TTable[1].size() << ", #buckets=" << TTable[1].bucket_count() << endl;
            use_tt = false;
        }

        float elapsed_time = Utils::read_time_in_seconds() - start_time;

        cout << npv + 1 - i << ". " << (color == 1 ? "Black" : "White") << " moves: "
             << "value=" << color * value
             << ", #expanded=" << expanded
             << ", #generated=" << generated
             << ", seconds=" << elapsed_time
             << ", #generated/second=" << generated/elapsed_time
             << endl;
    }

    return 0;
}

