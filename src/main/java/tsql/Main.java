package tsql;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import ws.idle.parsers.tsql.tsqlparser;
import ws.idle.parsers.tsql.tsqltokens;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.util.Objects;


/**
 * Test driver program for the TSQL Parser
 *
 * @author Jim Idle jimi@idle.ws
 */
class Main {

    static tsqltokens lexer;

    /**
     * Just a simple test driver for the ASP parser
     * to show how to call it.
     */

    public static void main(String[] args) {
        lexer = new tsqltokens(CharStreams.fromString(""));
        try {
            if (args.length > 0) {

                // Recursively parse each directory, and each file on the
                // command line
                //
                for (String arg : args) {
                    parse(new File(arg));
                }
            } else {
                System.err.println("Usage: java -jar tsql.jar <directory | filename>");
            }
        } catch (Exception ex) {
            System.err.println("TSQL 2005 parser threw exception:");
            ex.printStackTrace();
        }
    }

    public static void parse(File source) throws Exception {

        // Open the supplied file or directory
        //
        try {

            // From here, any exceptions are just thrown back up the chain
            //
            if (source.isDirectory()) {
                System.out.println("Directory: " + source.getAbsolutePath());
                String[] files = source.list();

                for (int i = 0; i < Objects.requireNonNull(files).length; i++) {
                    parse(new File(source, files[i]));
                }
            }

            // Else find out if it is an ASP.Net file and parse it if it is
            //
            else {
                // File without paths etc
                //
                String sourceFile = source.getName();

                if (sourceFile.length() > 3) {
                    String suffix = sourceFile.substring(sourceFile.length() - 4).toLowerCase();

                    // Ensure that this is a SQL script (or seemingly)
                    //
                    if (suffix.compareTo(".sql") == 0) {
                        parseSource(source.getAbsolutePath());
                    }
                }
            }
        } catch (Exception ex) {
            System.err.println("T-SQL 2005 parser caught error on file open:");
            ex.printStackTrace();
        }
    }

    public static void parseSource(String source) throws Exception {
        // Parse an ASP.Net page
        //

        try {
            // First create a file stream using the povided file/path
            // and tell the lexer that that is the character source.
            // You can also use text that you have already read of course
            // by using the string stream.
            //
            CharStream cs = CharStreams.fromFileName(source, StandardCharsets.UTF_8);
            lexer.setInputStream(cs);

            // Using the lexer as the token source, we create a token
            // stream to be consumed by the parser
            //
            CommonTokenStream tokens = new CommonTokenStream(lexer);

            // Now we need an instance of our parser
            //
            tsqlparser parser = new tsqlparser(tokens);

            System.out.println("file: " + source);
            System.out.println("    Lexer Start");
            long start = System.currentTimeMillis();
            tokens.LT(1); // Force token load and lex
            long lexerStop = System.currentTimeMillis();
            System.out.println("      lexed in " + (lexerStop - start) + "ms.");

            // And now we merely invoke the start rule for the parser
            //
            System.out.println("    Parser Start");
            long pStart = System.currentTimeMillis();
            parser.aaa_translation_unit();
            long stop = System.currentTimeMillis();
            System.out.println("      Parsed in " + (stop - pStart) + "ms.");
        } catch (Exception ex) {
            // Something went wrong in the parser, report this
            //
            System.err.println("Parser threw an exception:\n\n");
            ex.printStackTrace();
        }
    }
}
