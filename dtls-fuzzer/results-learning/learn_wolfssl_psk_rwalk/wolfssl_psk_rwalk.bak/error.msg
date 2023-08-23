null
Non-determinism detected
full input:
PSK_CLIENT_HELLO PSK_CLIENT_HELLO PSK_CLIENT_KEY_EXCHANGE CHANGE_CIPHER_SPEC FINISHED PSK_CLIENT_KEY_EXCHANGE
full new output:
HELLO_VERIFY_REQUEST SERVER_HELLO,PSK_SERVER_KEY_EXCHANGE,SERVER_HELLO_DONE TIMEOUT TIMEOUT CHANGE_CIPHER_SPEC,FINISHED CHANGE_CIPHER_SPEC,UNKNOWN_MESSAGE
old output:
HELLO_VERIFY_REQUEST SERVER_HELLO,PSK_SERVER_KEY_EXCHANGE,SERVER_HELLO_DONE TIMEOUT TIMEOUT CHANGE_CIPHER_SPEC,FINISHED CHANGE_CIPHER_SPECnull
	at se.uu.it.dtlsfuzzer.sut.MultipleRunsSULOracle.getProbabilisticOutput(MultipleRunsSULOracle.java:154)
	at se.uu.it.dtlsfuzzer.sut.MultipleRunsSULOracle.getMultipleRunOutput(MultipleRunsSULOracle.java:87)
	at se.uu.it.dtlsfuzzer.learn.CESanitizingSULOracle.getCheckedOutput(CESanitizingSULOracle.java:98)
	at se.uu.it.dtlsfuzzer.learn.CESanitizingSULOracle.processQuery(CESanitizingSULOracle.java:68)
	at de.learnlib.api.oracle.MembershipOracle.answerQuery(MembershipOracle.java:48)
	at de.learnlib.api.oracle.MembershipOracle.answerQuery(MembershipOracle.java:42)
	at se.uu.it.dtlsfuzzer.sut.CachingSULOracle.processQueries(CachingSULOracle.java:54)
	at se.uu.it.dtlsfuzzer.learn.RandomWpMethodEQOracle.doFindCounterExample(RandomWpMethodEQOracle.java:149)
	at se.uu.it.dtlsfuzzer.learn.RandomWpMethodEQOracle.findCounterExample(RandomWpMethodEQOracle.java:115)
	at se.uu.it.dtlsfuzzer.learn.RandomWpMethodEQOracle.findCounterExample(RandomWpMethodEQOracle.java:53)
	at de.learnlib.oracle.equivalence.EQOracleChain.findCounterExample(EQOracleChain.java:49)
	at se.uu.it.dtlsfuzzer.learn.Extractor.extractStateMachine(Extractor.java:234)
	at se.uu.it.dtlsfuzzer.DtlsFuzzer.extractModel(DtlsFuzzer.java:137)
	at se.uu.it.dtlsfuzzer.DtlsFuzzer.startTesting(DtlsFuzzer.java:66)
	at se.uu.it.dtlsfuzzer.Main.main(Main.java:49)
