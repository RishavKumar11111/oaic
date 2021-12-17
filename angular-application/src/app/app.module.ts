import { FormBuilder } from '@angular/forms';
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LayoutComponent } from './layout/layout.component';
import { HeaderComponent } from './layout/header/header.component';
import { FooterComponent } from './layout/footer/footer.component';
import { SidebarComponent } from './layout/sidebar/sidebar.component';
import { PageHeadingComponent } from './layout/page-heading/page-heading.component';
import { ToastrModule } from 'ngx-toastr';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';
import { CookieService } from 'ngx-cookie-service';
import { CsrfInterceptor } from './auth/csrf/csrf.interceptor';
import { ResolverResolver } from './auth/resolver/resolver.resolver';
import { CommonService } from './services/common.service';
import { LayoutService } from './services/layout/layout.service';

@NgModule({
  declarations: [
    AppComponent,
    LayoutComponent,
    HeaderComponent,
    FooterComponent,
    SidebarComponent,
    PageHeadingComponent
  ],
  imports: [
    HttpClientModule,
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot()
  ],
  providers: [
    CookieService,
    CsrfInterceptor,
    {
          provide: HTTP_INTERCEPTORS,
          useClass: CsrfInterceptor,
          multi: true
    },
    ResolverResolver,
    FormBuilder,
    CommonService,
    LayoutService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }