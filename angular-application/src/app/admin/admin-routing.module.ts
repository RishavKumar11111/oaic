import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const RoleObject = { Role: 'ADMIN' };

const routes: Routes = [
  {
    path: '',
    redirectTo: 'dm-list',
    pathMatch: 'full'
  },
  {
    path: 'dm-list',
    data: RoleObject,
    loadChildren: () => import('./dm-list/dm-list.module').then(module => module.DmListModule)
  },
  {
    path: 'accountant-list',
    data: RoleObject,
    loadChildren: () => import('./accountant-list/accountant-list.module').then(module => module.AccountantListModule)
  },
  {
    path: 'add-new-item',
      data: RoleObject,
    loadChildren: () => import('./item/add-item/add-item.module').then(module => module.AddItemModule)
  },
  {
    path: 'items-list',
      data: RoleObject,
    loadChildren: () => import('./item/items-list/items-list.module').then(module => module.ItemsListModule)
  },
  {
    path: 'approve-vendor',
    data: RoleObject,
    loadChildren: () => import('./vendor/approve-vendor/approve-vendor.module').then(module => module.ApproveVendorModule)
  },
  {
    path: 'vendors-list',
    data: RoleObject,
    loadChildren: () => import('./vendor/vendor-list/vendor-list.module').then(module => module.VendorListModule)
  },
  {
    path: 'payment-receive-other-source',
    data: RoleObject,
    loadChildren: () => import('./payment-received-from-source/payment-received-from-source.module').then(module => module.PaymentReceivedFromSourceModule)
  },
  {
    path: 'audit-log',
    data: RoleObject,
    loadChildren: () => import('./audit-log/audit-log.module').then(module => module.AuditLogModule)
  },
  {
    path: 'add-customer',
    data: RoleObject,
    loadChildren: () => import('./customer/add-customer/add-customer.module').then(module => module.AddCustomerModule)
  },
  {
    path: 'customer-list',
    data: RoleObject,
    loadChildren: () => import('./customer/customer-list/customer-list.module').then(module => module.CustomerListModule)
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminRoutingModule { }
