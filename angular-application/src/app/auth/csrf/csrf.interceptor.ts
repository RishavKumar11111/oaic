import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { AuthService } from 'src/app/services/auth/auth.service';

@Injectable()
export class CsrfInterceptor implements HttpInterceptor {

  constructor(private layoutService: LayoutService, private authService: AuthService) {}

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    const userToken = this.layoutService.getCSRFToken();
    const accessToken = this.authService.getAccessToken();
    const isSkip = request.headers.get('skip');
    
    const modifiedRequest = request.clone({
      withCredentials: true,
      setHeaders: {
        'csrf-token': userToken,
        'Authorization': `Bearer ${accessToken}`
      }
    });
    let newRequest = request.clone({
          headers: request.headers.delete('skip')
    });
    return next.handle(isSkip == 'true' ? newRequest : modifiedRequest);

  }
}