abstract class IAppLifeCycleService {
  Stream<bool> get isResumedStream;
  Future<void> close();
}
