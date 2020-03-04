/*** 
 Purpose: Assign integer values to variable names
 using var_name = int. If the variable name has
 been assigned a value, then be able to output the
 value using a single line command "var_name".
***/

%{
#include <iostream>
#include <map>
#include <string>
#include <algorithm>

#define YY_DECL extern "C" int yylex()

std::map <std::string, int> var_to_int;

%}
/***
 We define token names to associate with the
 simple regex matches to create more complicated
 combinations of the tokens in the grammar rules
***/

WS [ \t]
NL [\n]
VARNAME [a-zA-Z][a-zA-Z0-9]*
FLOAT [0-9]+\.[0-9]+ 
INT [0-9]+

/*** Grammar Rules ***/

%%
{NL}            ; // Do nothing

{VARNAME}       {
                  // Convert the word to a null-terminated std::string
                  std::string yytext_str(yytext);

                  // Use iterator to search whether var name has been used
                  auto iter = var_to_int.find(yytext_str);
                  // If found, then print the int value assigned
                  if (iter != var_to_int.end()) {
                    std::cout << iter->second << std::endl;
                  }
                  // Otherwise, return the var_name
                  else {
                    std::cout << yytext_str << std::endl;
                  }
                }

{VARNAME}{WS}*={WS}*{INT} {
                  // Convert the match to a null-terminated std::string
                  std::string yytext_str(yytext);

                  // Remove all spaces within the std::string
                  yytext_str.erase(std::remove(yytext_str.begin(), yytext_str.end(), ' '), 
                    yytext_str.end());

                  // Remove all tabs within the std::string
                  yytext_str.erase(std::remove(yytext_str.begin(), yytext_str.end(), '\t'), 
                    yytext_str.end());

                  // Split the string into the name and int values. Store 
                  // the result in the std::map<std::string, int>.
                  unsigned int equalsPos = yytext_str.find('=');
                  var_to_int[yytext_str.substr(0,equalsPos)] = std::stoi(yytext_str.substr(equalsPos+1));
                }



%%

int main(int argc, char**argv) {

    // Perform the lex loop on the input
    yylex();
}