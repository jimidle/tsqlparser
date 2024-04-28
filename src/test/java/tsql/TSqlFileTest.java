package tsql;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
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
        parser.addErrorListener(errorListener); // add our custom error listener
        parser.aaa_translation_unit();
        if (errorListener.isErrorOccurred()) {
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
