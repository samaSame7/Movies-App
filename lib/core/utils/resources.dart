enum ApiStatus{
  loading,
  success,
  initial,
  error;
}

class Resource<T> {
  T? data=null;
  late bool isLoading = false;
  late String? errMessage;
  late ApiStatus status;
  Resource(this.status,this.isLoading,this.errMessage,this.data);
  Resource.loading(){
    isLoading=true;
    status=ApiStatus.loading;

  }
  Resource.success(this.data){
    status=ApiStatus.success;
  }
  Resource.error(String error){
    errMessage=error;
    status=ApiStatus.error;
  }
  Resource.initial(){
    status=ApiStatus.initial;
  }
}
