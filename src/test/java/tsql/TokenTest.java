package tsql;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.Token;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import ws.idle.parsers.tsql.TSqlTokens;

import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertEquals;

class TokenTest {

    static Stream<Arguments> provideTokens() {
        // Reduce text length for clarity
        int DEFAULT = TSqlTokens.DEFAULT_TOKEN_CHANNEL;
        int HIDDEN = TSqlTokens.HIDDEN;
        return Stream.of(
                Arguments.of(TSqlTokens.COMMA, DEFAULT, ","),
                Arguments.of(TSqlTokens.DOT, DEFAULT, "."),
                Arguments.of(TSqlTokens.LPAREN, DEFAULT, "("),
                Arguments.of(TSqlTokens.RPAREN, DEFAULT, ")"),
                Arguments.of(TSqlTokens.DOLLAR, DEFAULT, "$"),
                Arguments.of(TSqlTokens.OPPLUSEQ, DEFAULT, "+="),
                Arguments.of(TSqlTokens.OPPLUS, DEFAULT, "+"),
                Arguments.of(TSqlTokens.BANG, DEFAULT, "!"),
                Arguments.of(TSqlTokens.OPMINUSEQ, DEFAULT, "-="),
                Arguments.of(TSqlTokens.OPMINUS, DEFAULT, "-"),
                Arguments.of(TSqlTokens.OPMULEQ, DEFAULT, "*="),
                Arguments.of(TSqlTokens.OPMUL, DEFAULT, "*"),
                Arguments.of(TSqlTokens.OPDIVEQ, DEFAULT, "/="),
                Arguments.of(TSqlTokens.OPDIV, DEFAULT, "/"),
                Arguments.of(TSqlTokens.OPMODEQ, DEFAULT, "%="),
                Arguments.of(TSqlTokens.OPMOD, DEFAULT, "%"),
                Arguments.of(TSqlTokens.OPBANDEQ, DEFAULT, "&="),
                Arguments.of(TSqlTokens.OPBAND, DEFAULT, "&"),
                Arguments.of(TSqlTokens.OPBOREQ, DEFAULT, "|="),
                Arguments.of(TSqlTokens.OPBOR, DEFAULT, "|"),
                Arguments.of(TSqlTokens.OPBXOREQ, DEFAULT, "^="),
                Arguments.of(TSqlTokens.OPBXOR, DEFAULT, "^"),
                Arguments.of(TSqlTokens.OPBNOT, DEFAULT, "~"),
                Arguments.of(TSqlTokens.OPEQ, DEFAULT, "="),
                Arguments.of(TSqlTokens.OPGT, DEFAULT, ">"),
                Arguments.of(TSqlTokens.OPLT, DEFAULT, "<"),
                Arguments.of(TSqlTokens.OPGE, DEFAULT, ">="),
                Arguments.of(TSqlTokens.OPLE, DEFAULT, "<="),
                Arguments.of(TSqlTokens.OPNE, DEFAULT, "<>"),
                Arguments.of(TSqlTokens.OPNE, DEFAULT, "!="),
                Arguments.of(TSqlTokens.OPNLT, DEFAULT, "!<"),
                Arguments.of(TSqlTokens.OPNGT, DEFAULT, "!>"),
                Arguments.of(TSqlTokens.OPSEQ, DEFAULT, "=*"),
                Arguments.of(TSqlTokens.COLON, DEFAULT, ":"),
                Arguments.of(TSqlTokens.SEMI, DEFAULT, ";"),

                Arguments.of(TSqlTokens.LPAREN, DEFAULT, "("),
                Arguments.of(TSqlTokens.INTEGER, DEFAULT, "42"),
                Arguments.of(TSqlTokens.INTEGER, DEFAULT, "4"),
                Arguments.of(TSqlTokens.DECIMAL, DEFAULT, "37.42"),
                Arguments.of(TSqlTokens.FLOAT, DEFAULT, "1.7e-42"),
                Arguments.of(TSqlTokens.FLOAT, DEFAULT, "1E-42"),
                Arguments.of(TSqlTokens.FLOAT, DEFAULT, "11E-42"),

                // This parser expects UNIX sane files that end in \n
                Arguments.of(TSqlTokens.COMMENT, HIDDEN, "-- This is a comment\n"),
                Arguments.of(TSqlTokens.SQ_LITERAL, DEFAULT, "'single quoted literal'"),
                Arguments.of(TSqlTokens.SQ_LITERAL, DEFAULT, "''"), // empty single quoted literal

                Arguments.of(TSqlTokens.DQ_LITERAL, DEFAULT, "\"double quoted literal\""),
                Arguments.of(TSqlTokens.DQ_LITERAL, DEFAULT, "\"\""), // empty double quoted literal

                Arguments.of(TSqlTokens.BR_LITERAL, DEFAULT, "[bracketed literal]"),
                Arguments.of(TSqlTokens.BR_LITERAL, DEFAULT, "[]"), // empty bracketed literal

                Arguments.of(TSqlTokens.ML_COMMENT, HIDDEN, "/* This is a multi-line comment */"),
                Arguments.of(TSqlTokens.ML_COMMENT, HIDDEN, "/* This is a multi-line \n comment with a newline */"),
                Arguments.of(TSqlTokens.ML_COMMENT, HIDDEN, "/* This is a multi-line \n comment with multiple \n newlines */"),
                Arguments.of(TSqlTokens.ML_COMMENT, HIDDEN, "/* This is a multi-line comment with an embedded comment: /* embedded comment */ */"),
                Arguments.of(TSqlTokens.ML_COMMENT, HIDDEN, "/**/"), // empty multi-line comment

                Arguments.of(TSqlTokens.HEXNUM, DEFAULT, "0x"), // zero? Who knows but tsql supports it
                Arguments.of(TSqlTokens.HEXNUM, DEFAULT, "0x0"), // zero
                Arguments.of(TSqlTokens.HEXNUM, DEFAULT, "0x1"), // one
                Arguments.of(TSqlTokens.HEXNUM, DEFAULT, "0xA"), // ten
                Arguments.of(TSqlTokens.HEXNUM, DEFAULT, "0xF"), // fifteen
                Arguments.of(TSqlTokens.HEXNUM, DEFAULT, "0x10"), // sixteen
                Arguments.of(TSqlTokens.HEXNUM, DEFAULT, "0xFF"), // 255
                Arguments.of(TSqlTokens.HEXNUM, DEFAULT, "0xCAFEBABE"), // arbitrary large number
                
                // A few random keywords - expand if problems are ever found with a KEYWORD such as it is missing
                Arguments.of(TSqlTokens.ACCESS, DEFAULT, "ACCESS"),
                Arguments.of(TSqlTokens.HELP, DEFAULT, "HELP"),
                Arguments.of(TSqlTokens.INDEXDEFRAG, DEFAULT, "INDEXDEFRAG"),
                Arguments.of(TSqlTokens.OPENTRAN, DEFAULT, "OPENTRAN"),
                Arguments.of(TSqlTokens.SHOWCONTIG, DEFAULT, "SHOWCONTIG"),
                Arguments.of(TSqlTokens.TRACEON, DEFAULT, "TRACEON"),
                Arguments.of(TSqlTokens.USEROPTIONS, DEFAULT, "USEROPTIONS"),
                Arguments.of(TSqlTokens.SELECT, DEFAULT, "SELECT"),

                Arguments.of(TSqlTokens.ID, DEFAULT, "identifier"), // simple identifier
                Arguments.of(TSqlTokens.ID, DEFAULT, "_identifier"), // identifier starting with underscore
                Arguments.of(TSqlTokens.ID, DEFAULT, "@identifier"), // identifier starting with @
                Arguments.of(TSqlTokens.ID, DEFAULT, "#identifier"), // identifier starting with #
                Arguments.of(TSqlTokens.ID, DEFAULT, "identifier$"), // identifier ending with $
                Arguments.of(TSqlTokens.BR_LITERAL, DEFAULT, "[identifier]"), // bracketed identifier
                Arguments.of(TSqlTokens.ID, DEFAULT, "identifier42$_"), // identifier with numbers and underscore

                Arguments.of(TSqlTokens.BAD_CHARACTER, DEFAULT, "☯"), // Character that matches no token
                Arguments.of(TSqlTokens.NTILE, DEFAULT, "NTILE")
        );
    }

    @ParameterizedTest
    @MethodSource("provideTokens")
    void testToken(int tokenType, int channel, String text) {
        CharStream cs = CharStreams.fromString(text);
        TSqlTokens lexer = new TSqlTokens(cs);
        lexer.setChannel(channel);
        Token token = lexer.nextToken();
        assertEquals(tokenType, token.getType());
    }
}