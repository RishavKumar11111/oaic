import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const RoleObject = { Role: 'DM' };

const routes: Routes = [
  {
    path: '',
    redirectTo: 'approve-purchase-order',
    pathMatch: 'full'
  },
  {
    path: 'approve-payment',
    loadChildren: () => import('./approve-payments/approve-payments.module').then(module => module.ApprovePaymentsModule),
    data: RoleObject
  },
  {
    path: 'approved-payments-list',
    loadChildren: () => import('./approved-payment-list/approved-payment-list.module').then(module => module.ApprovedPaymentListModule),
    data: RoleObject
  },
  {
    path: 'approve-purchase-order',
    loadChildren: () => import('./approve-purchase-order/approve-purchase-order.module').then(module => module.ApprovePurchaseOrderModule),
    data: RoleObject
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DmRoutingModule { }
