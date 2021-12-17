var app = angular.module("myApp", [])
app.controller("myCtrl", function($scope, $http) {
    $scope.fin_year = c_fin_year;
    $scope.loader = true;
    $scope.header = false;
    $scope.page1 = false;
    $scope.ledgerTable = false;
    $http.get('/api/getFinYear')
        .then(response => {
            $scope.fin_year_list = response.data;
            $scope.header = true;
            $scope.loader = false;
        });
});