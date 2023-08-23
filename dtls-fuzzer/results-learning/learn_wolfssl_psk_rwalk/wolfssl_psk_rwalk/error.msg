null
Non-determinism detected
full input:
PSK_CLIENT_HELLO PSK_CLIENT_HELLO PSK_CLIENT_KEY_EXCHANGE CHANGE_CIPHER_SPEC FINISHED PSK_CLIENT_KEY_EXCHANGE FINISHED FINISHED PSK_CLIENT_KEY_EXCHANGE Alert(WARNING,CLOSE_NOTIFY) PSK_CLIENT_HELLO
full new output:
HELLO_VERIFY_REQUEST SERVER_HELLO,PSK_SERVER_KEY_EXCHANGE,SERVER_HELLO_DONE TIMEOUT TIMEOUT CHANGE_CIPHER_SPEC,FINISHED CHANGE_CIPHER_SPEC,UNKNOWN_MESSAGE TIMEOUT TIMEOUT CHANGE_CIPHER_SPEC,UNKNOWN_MESSAGE UNKNOWN_MESSAGE TIMEOUT
old output:
HELLO_VERIFY_REQUEST SERVER_HELLO,PSK_SERVER_KEY_EXCHANGE,SERVER_HELLO_DONE TIMEOUT TIMEOUT CHANGE_CIPHER_SPEC,FINISHED CHANGE_CIPHER_SPEC,UNKNOWN_MESSAGE TIMEOUT TIMEOUT CHANGE_CIPHER_SPEC,UNKNOWN_MESSAGE Alert(UNDEFINED,4),Alert(UNDEFINED,39)null
	at se.uu.it.dtlsfuzzer.sut.ObservationTree.addObservation(ObservationTree.java:133)
	at se.uu.it.dtlsfuzzer.sut.ObservationTree.addObservation(ObservationTree.java:113)
	at se.uu.it.dtlsfuzzer.sut.CachingSULOracle.storeToCache(CachingSULOracle.java:68)
	at se.uu.it.dtlsfuzzer.sut.CachingSULOracle.processQueries(CachingSULOracle.java:56)
	at de.learnlib.datastructure.discriminationtree.model.AbstractDiscriminationTree.sift(AbstractDiscriminationTree.java:127)
	at de.learnlib.algorithms.ttt.base.BaseTTTDiscriminationTree.sift(BaseTTTDiscriminationTree.java:73)
	at de.learnlib.algorithms.ttt.base.AbstractTTTLearner.updateDTTargets(AbstractTTTLearner.java:890)
	at de.learnlib.algorithms.ttt.base.AbstractTTTLearner.closeTransitions(AbstractTTTLearner.java:799)
	at de.learnlib.algorithms.ttt.base.AbstractTTTLearner.closeTransitions(AbstractTTTLearner.java:764)
	at de.learnlib.algorithms.ttt.base.AbstractTTTLearner.refineHypothesisSingle(AbstractTTTLearner.java:213)
	at de.learnlib.algorithms.ttt.mealy.TTTLearnerMealy.refineHypothesisSingle(TTTLearnerMealy.java:67)
	at de.learnlib.algorithms.ttt.base.AbstractTTTLearner.refineHypothesis(AbstractTTTLearner.java:166)
	at se.uu.it.dtlsfuzzer.learn.Extractor.extractStateMachine(Extractor.java:239)
	at se.uu.it.dtlsfuzzer.DtlsFuzzer.extractModel(DtlsFuzzer.java:137)
	at se.uu.it.dtlsfuzzer.DtlsFuzzer.startTesting(DtlsFuzzer.java:66)
	at se.uu.it.dtlsfuzzer.Main.main(Main.java:49)
