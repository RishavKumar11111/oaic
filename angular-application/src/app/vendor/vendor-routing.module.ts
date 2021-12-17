import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const RoleObject = { Role: 'DEALER' };

const routes: Routes = [
  {
    path: '',
    redirectTo: 'all-purchase-orders-list',
    pathMatch: 'full'
  },
  {
    path: 'all-purchase-orders-list',
    data: RoleObject,
    loadChildren: () => import('./all-po-list/all-po-list.module').then(module => module.AllPoListModule)
  },
  {
    path: 'deliver-order',
    data: RoleObject,
    loadChildren: () => import('./deliver-order/deliver-order.module').then(module => module.DeliverOrderModule)
  },
  {
    path: 'deliver-report',
    data: RoleObject,
    loadChildren: () => import('./deliver-report/deliver-report.module').then(module => module.DeliverReportModule)
  },
  {
    path: 'withheld-amount',
    data: RoleObject,
    loadChildren: () => import('./withheld-amount/withheld-amount.module').then(module => module.WithheldAmountModule)
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class VendorRoutingModule { }
