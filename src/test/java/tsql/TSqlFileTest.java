package tsql;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.atn.PredictionMode;
import org.jetbrains.annotations.NotNull;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import ws.idle.parsers.tsql.TSqlParser;
import ws.idle.parsers.tsql.TSqlTokens;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.fail;

class TSqlFileTest {

    @BeforeAll
    static void setUp() {
        // Do nothing
    }

    @ParameterizedTest
    @MethodSource("provideGoodFiles")
    void testSQLGoodFile(@NotNull File file) throws IOException {
        CharStream cs = CharStreams.fromPath(file.toPath());
        TSqlTokens lexer = new TSqlTokens(cs);
        TSqlParser parser = new TSqlParser(new CommonTokenStream(lexer));
        TestErrorListener errorListener = new TestErrorListener();
        // Try parsing with SLL(*) strategy, which is fast but not good with complex ambiguities
        // It is faster and will parse almost everything correctly though. We don't report errors with this strategy
        // as if we get any then we retry with the full LL(*) strategy
        parser.removeErrorListeners();
        // Our listener only counts errors, we don't want to print them
        parser.addErrorListener(errorListener);
        parser.getInterpreter().setPredictionMode(PredictionMode.SLL);
        TSqlParser.Aaa_translation_unitContext tree = null;
        boolean caught = false;
        try {
            tree = parser.aaa_translation_unit();
        } catch (Exception e) {
            caught = true;
        }
            // If we reach this point, parsing with SLL(*) was successful
        if (errorListener.isErrorOccurred() || caught) {
            // Parsing with SLL(*) failed, reset the input stream and try with LL(*)
            System.out.println("Parsing " + file + "  with SLL(*) failed, dropping back to LL(*)");
            cs = CharStreams.fromPath(file.toPath());
            lexer = new TSqlTokens(cs);
            parser = new TSqlParser(new CommonTokenStream(lexer));
            errorListener.reset();

            // add diagnostic error listener to report all ambiguities if we have a long parse
            // parser.addErrorListener(new DiagnosticErrorListener(true));
            parser.addErrorListener(errorListener);
            tree = parser.aaa_translation_unit();

        }

        // Generate dot spec etc
        DotGen dotGenerator = new DotGen(tree, parser, file);
        dotGenerator.writeTreeFor();
        dotGenerator.writeDotFor();
        dotGenerator.writeSvgFor();

        if (errorListener.isErrorOccurred()) {
            System.out.println("Check the .txt, and .svg files for the parse tree, and visual");
            fail("Syntax error in file: " + file);
        }
    }

    @ParameterizedTest
    @MethodSource("provideBadFiles")
    void testSQLBadFile(@NotNull File file) throws IOException {
        CharStream cs = CharStreams.fromPath(file.toPath());
        TSqlTokens lexer = new TSqlTokens(cs);
        TSqlParser parser = new TSqlParser(new CommonTokenStream(lexer));
        TestErrorListener errorListener = new TestErrorListener();
        parser.removeErrorListeners(); // remove the default error listener
        parser.addErrorListener(errorListener); // add our custom error listener
        parser.aaa_translation_unit();
        if (!errorListener.isErrorOccurred()) {
            fail("Syntax error was not caught " + file);
        }
    }

    static Stream<File> provideGoodFiles() throws IOException {
        return Files.walk(Paths.get("src/test/resources/regression/should_parse")).filter(path -> Files.isRegularFile(path) && path.toString().endsWith(".sql"))
                .sorted()
                .map(Path::toFile);
    }

    static Stream<File> provideBadFiles() throws IOException {
        return Files.walk(Paths.get("src/test/resources/regression/should_fail")).filter(path -> Files.isRegularFile(path) && path.toString().endsWith(".sql"))
                .sorted()
                .map(Path::toFile);
    }
}
