import { Injectable } from '@angular/core';
import {
  Router, Resolve,
  RouterStateSnapshot,
  ActivatedRouteSnapshot
} from '@angular/router';
import { Observable, of } from 'rxjs';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';


@Injectable({
  providedIn: 'root'
})
export class ResolverResolver implements Resolve<any> {
  constructor(
    private layoutService: LayoutService,
    private service: CommonService
    ) {}
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any> | Promise<any> {
    return new Promise(async (resolve, reject) => {
      try {
        const response = await this.service.get('/api/UserLoginDetails')
        this.layoutService.setCSRFToken(response.CSRFToken)
        this.layoutService.setUserID(response.UserID)
        this.layoutService.setUserName(response.UserName)
        this.layoutService.setUserRole(response.UserRole)
        this.layoutService.setCurrentDate(response.currentDate)
        this.layoutService.setDistrictID(response.DistrictID)
        resolve(true)
      } catch(e) {
        this.layoutService.goToLoginPage()
        reject()
      }
    })
  }
}
