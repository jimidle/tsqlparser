package tsql;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.jetbrains.annotations.NotNull;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import ws.idle.parsers.tsql.tsqlparser;
import ws.idle.parsers.tsql.tsqltokens;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.fail;

class SQLFileTest {


    @BeforeAll
    static void setUp() {
        // Initialize the lexer and parser here
        // This is just an example, replace with your actual initialization code

    }

    @ParameterizedTest
    @MethodSource("provideGoodFiles")
    void testSQLGoodFile(@NotNull File file) throws IOException {
        CharStream cs = CharStreams.fromPath(file.toPath());
        tsqltokens lexer = new tsqltokens(cs);
        tsqlparser parser = new tsqlparser(new CommonTokenStream(lexer));
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
        tsqltokens lexer = new tsqltokens(cs);
        tsqlparser parser = new tsqlparser(new CommonTokenStream(lexer));
        TestErrorListener errorListener = new TestErrorListener();
        parser.removeErrorListeners(); // remove the default error listener
        parser.addErrorListener(errorListener); // add our custom error listener
        parser.aaa_translation_unit();
        if (!errorListener.isErrorOccurred()) {
            fail("Syntax error was not caught " + file);
        }
    }

    static Stream<File> provideGoodFiles() throws IOException {
        return Files.walk(Paths.get("src/test/resources/regression/should_parse")).filter(path -> Files.isRegularFile(path) && path.toString().endsWith(".sql")).map(Path::toFile);
    }

    static Stream<File> provideBadFiles() throws IOException {
        return Files.walk(Paths.get("src/test/resources/regression/should_fail")).filter(path -> Files.isRegularFile(path) && path.toString().endsWith(".sql")).map(Path::toFile);
    }


}
