import { Injectable } from '@angular/core';
import { PreloadAllModules, Route } from '@angular/router';
import { Observable, of } from 'rxjs';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Injectable({
  providedIn: 'root'
})
export class CustomPreLoadingStrategyService implements PreloadAllModules {

  constructor(private layoutService: LayoutService) { }

  preload(route: Route, fn: () => Observable<any>): Observable<any> {
    const userRole = this.layoutService.getUserRole();
    // console.log(userRole, route.data?.Role, route.path);
    
    if (userRole == route.data?.Role) {
      console.log(route.path);
      return fn();
    }
    return of(null);
  }




  // routes: { [name: string]: { route: Route; load: Function } } = {};
  
  // preload(route: Route, load: Function): Observable<any> {
  //   console.log(route.path);

  //   if (route.data && route.data['preload']) {
  //     // load();
  //     this.routes[route.data.name] = {
  //       route,
  //       load
  //     };
  //   }

  //   return of(null);
  // }

  // preLoadRoute(name: string) {
  //   const route = this.routes[name];
  //   if (route) {
  //     route.load();
  //   }
  // }



}
