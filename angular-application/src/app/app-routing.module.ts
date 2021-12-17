import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ResolverResolver } from './auth/resolver/resolver.resolver';
import { LayoutComponent } from './layout/layout.component';
import { RoutePermissionGuard } from './auth/route-permission/route-permission.guard';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'auth',
    pathMatch: 'full'
  },
  {
    path: 'auth',
    resolve: { preData: ResolverResolver },
    loadChildren: () => import('./auth/auth.module').then(module => module.AuthModule)
  },
  {
    path: 'dm',
    canLoad: [ RoutePermissionGuard ],
    resolve: { preData: ResolverResolver },
    canActivateChild: [ RoutePermissionGuard ],
    data: { Role: 'DM', preload: true },
    component: LayoutComponent,
    loadChildren: () => import('./dm/dm.module').then(module => module.DmModule),
  },
  {
    path: 'admin',
    canLoad: [ RoutePermissionGuard ],
    canActivateChild: [ RoutePermissionGuard ],
    resolve: { preData: ResolverResolver },
    data: { Role: 'ADMIN', preload: true },
    component: LayoutComponent,
    loadChildren: () => import('./admin/admin.module').then(module => module.AdminModule),
  },
  {
    path: 'accountant',
    canLoad: [ RoutePermissionGuard ],
    canActivateChild: [ RoutePermissionGuard ],
    resolve: { preData: ResolverResolver },
    data: { Role: 'ACCOUNTANT', preload: true },
    component: LayoutComponent,
    loadChildren: () => import('./accountant/accountant.module').then(module => module.AccountantModule)
  },
  {
    path: 'vendor',
    canLoad: [ RoutePermissionGuard ],
    canActivateChild: [ RoutePermissionGuard ],
    resolve: { preData: ResolverResolver },
    data: { Role: 'DEALER' },
    component: LayoutComponent,
    loadChildren: () => import('./vendor/vendor.module').then(module => module.VendorModule)
  },
  {
    path: 'bank',
    canLoad: [ RoutePermissionGuard ],
    canActivateChild: [ RoutePermissionGuard ],
    resolve: { preData: ResolverResolver },
    data: { Role: 'BANK' },
    component: LayoutComponent,
    loadChildren: () => import('./bank/bank.module').then(module => module.BankModule)
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { useHash: true })],
  // imports: [RouterModule.forRoot(routes, { useHash: true, preloadingStrategy: CustomPreLoadingStrategyService })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
