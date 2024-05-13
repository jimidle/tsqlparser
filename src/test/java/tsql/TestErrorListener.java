package tsql;

import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

public class TestErrorListener extends BaseErrorListener {
    private boolean errorOccurred = false;

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
        // If there is no RecognitionException, then we have just a diagnostic report for ambiguity
        // and ignore it for errors as the diagnostic listener will report it in a more sensible
        if (e != null) {
            errorOccurred = true;
        }
    }

    public boolean isErrorOccurred() {
        return errorOccurred;
    }

    public void reset() {
        errorOccurred = false;
    }
}