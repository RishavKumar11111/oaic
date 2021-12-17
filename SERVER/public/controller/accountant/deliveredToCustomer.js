var app = angular.module("myApp", [])
app.controller("myCtrl", function ($scope, $http) {
    var dist_id = document.querySelector('meta[name="distcode"]').getAttribute('content');
    $scope.showTable = false;
    $scope.loader = false;
    $scope.fin_year = c_fin_year;
    $http.get('/api/getFinYear')
    .then(response => {
        $scope.fin_year_list = response.data;
    });
    $http.get('/accountant/getDMDetails')
        .then(response => {
            $scope.DMDetails = response.data;
        });
    $scope.loadList = function() {
        $scope.loader = true;
        $http.get('/accountant/getAllDeliveredToCustomerOrders?dist_id='+dist_id+'&fin_year='+$scope.fin_year)
            .then(response => {
                $scope.items = response.data;
                $scope.loader = false;
                $scope.showTable = true;
        })
    }
    $scope.loadList();
});