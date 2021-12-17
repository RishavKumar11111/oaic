import { ToastrService } from 'ngx-toastr';
import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, CanActivate, CanActivateChild, CanDeactivate, CanLoad, Route, RouterStateSnapshot, UrlSegment, UrlTree } from '@angular/router';
import { Observable } from 'rxjs';
import { CommonService } from 'src/app/services/common.service';
import { environment } from 'src/environments/environment.prod';

@Injectable({
  providedIn: 'root'
})
export class RoutePermissionGuard implements CanActivate, CanActivateChild, CanDeactivate<unknown>, CanLoad {

  constructor(
    private service: CommonService,
    private toastr: ToastrService
    ) {  }
  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
      return new Promise(async (resolve, reject) => {
        const result: any = await this.checkPermission(route.data.Role);
        resolve(result);
    });
  }
  canActivateChild(
    childRoute: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {      
      return childRoute.url.length ? this.canActivate(childRoute, state) : true;
      
  }
  canDeactivate(
    component: unknown,
    currentRoute: ActivatedRouteSnapshot,
    currentState: RouterStateSnapshot,
    nextState?: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
    return true;
  }
  canLoad(
    route: Route,
    segments: UrlSegment[]): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
      return new Promise( async (resolve, reject) => {
        const result: any = await this.checkPermission(route.data?.Role);
        resolve(result);
      })
  }





  checkPermission = (role: string) => {
    return new Promise( async (resolve, reject) => {
      try {
            const Role = role;              
            const isValid = await this.service.get(`/api/checkUserPemission/${Role}`);
            if(isValid) {
              resolve(true);
            } else {
              resolve(false);
              this.toastr.error('Invalid User. Sign in Again.');
              setTimeout(() => {
                window.location.replace(`${environment.server_url}/login`);
              }, 800)
            }
      } catch(e) {
          console.error(e);
          resolve(false);
          this.toastr.error('Invalid User. Sign in Again.');
          setTimeout(() => {
            window.location.replace(`${environment.server_url}/login`);
          }, 800)
      }
    })
  }






}
