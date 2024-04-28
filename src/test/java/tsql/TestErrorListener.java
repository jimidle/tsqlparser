package tsql;

import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

public class TestErrorListener extends BaseErrorListener {
    private boolean errorOccurred = false;

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
        errorOccurred = true;
    }

    public boolean isErrorOccurred() {
        return errorOccurred;
    }

    public void reset() {
        errorOccurred = false;
    }
}