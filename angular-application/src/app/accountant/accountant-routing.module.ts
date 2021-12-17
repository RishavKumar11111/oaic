import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const RoleObject = { Role: 'ACCOUNTANT' };

const routes: Routes = [
  {
    path: '',
    redirectTo: 'receive-money-against-permit',
    pathMatch: 'full'
  },
  {
    path: 'receive-money-against-permit',
    data: RoleObject,
    loadChildren: () => import('./money-receipt/against-permit/against-permit.module').then(module => module.AgainstPermitModule)
  },
  {
    path: 'partly-money-receive',
    data: RoleObject,
    loadChildren: () => import('./money-receipt/partly-money-receive/partly-money-receive.module').then(module => module.PartlyMoneyReceiveModule)
  },
  {
    path: 'receive-payments',
    data: RoleObject,
    loadChildren: () => import('./money-receipt/receive-payments/receive-payments.module').then(m => m.ReceivePaymentsModule)
  },
  {
    path: 're-print-money-receipt',
    data: RoleObject,
    loadChildren: () => import('./money-receipt/re-print-money-receipt/re-print-money-receipt.module').then(module => module.RePrintMoneyReceiptModule)
  },
  {
    path: 'po/initiate',
    data: RoleObject,
    loadChildren: () => import('./po/initiate/initiate.module').then(module => module.InitiateModule)
  },
  {
    path: 'po/re-print',
    data: RoleObject,
    loadChildren: () => import('./po/re-print/re-print.module').then(module => module.RePrintModule)
  },
  {
    path: 'po/cancellation',
    data: RoleObject,
    loadChildren: () => import('./po/cancellation/cancellation.module').then(module => module.CancellationModule)
  },
  {
    path: 'po/report',
    data: RoleObject,
    loadChildren: () => import('./po/report/report.module').then(module => module.ReportModule)
  },
  {
    path: 'generate-mrr',
    data: RoleObject,
    loadChildren: () => import('./mrr/generate-mrr/generate-mrr.module').then(m => m.GenerateMrrModule)
  },
  {
    path: 're-print-mrr',
    data: RoleObject,
    loadChildren: () => import('./mrr/re-print-mrr/re-print-mrr.module').then(m => m.RePrintMrrModule)
  },
  {
    path: 'stock',
    data: RoleObject,
    loadChildren: () => import('./stock/stock.module').then(m => m.StockModule)
  },
  {
    path: 'job-book',
    data: RoleObject,
    loadChildren: () => import('./job-book/job-book.module').then(m => m.JobBookModule)
  },
  {
    path: 'miscellaneous-expenses',
    data: RoleObject,
    loadChildren: () => import('./miscellaneous-expenses/miscellaneous-expenses.module').then(m => m.MiscellaneousExpensesModule)
  },
  {
    path: 'project-wise-ledger',
    data: RoleObject,
    loadChildren: () => import('./ledger/project-wise-ledger/project-wise-ledger.module').then(module => module.ProjectWiseLedgerModule)
  },
  {
    path: 'vendor-wise-ledger',
    data: RoleObject,
    loadChildren: () => import('./ledger/vendor-wise-ledger/vendor-wise-ledger.module').then(module => module.VendorWiseLedgerModule)
  },
  {
    path: 'global-ledger',
    data: RoleObject,
    loadChildren: () => import('./ledger/global-ledger/global-ledger.module').then(module => module.GlobalLedgerModule)
  },
  {
    path: 'receipts',
    data: RoleObject,
    loadChildren: () => import('./cashbook/reciept/reciept.module').then(module => module.RecieptModule)
  },
  {
    path: 'payments',
    data: RoleObject,
    loadChildren: () => import('./cashbook/payments/payments.module').then(module => module.PaymentsModule)
  },
  {
    path: 'consolidated-cashbook',
    data: RoleObject,
    loadChildren: () => import('./cashbook/consolidated/consolidated.module').then(module => module.ConsolidatedModule)
  },
  {
    path: 'paid-opening-balance',
    data: RoleObject,
    loadChildren: () => import('./backlog-balance/pay-money/pay-money.module').then(module => module.PayMoneyModule)
  },
  {
    path: 'recieve-opening-balance',
    data: RoleObject,
    loadChildren: () => import('./backlog-balance/receive-money/receive-money.module').then(module => module.ReceiveMoneyModule)
  },
  {
    path: 'deliver-Generate-Invoice',
    data: RoleObject,
    loadChildren: () => import('./Invoice/deliver-generate-invoice/deliver-generate-invoice.module').then(module => module.DeliverGenerateInvoiceModule)
  },
  {
    path: 'reprint',
    data: RoleObject,
    loadChildren: () => import('./Invoice/re-print/re-print.module').then(module => module.RePrintModule)
  },
  {
    path: 'Pay-to-vendor',
    data: RoleObject,
    loadChildren: () => import('./VendorPay/pay-to-vendor/pay-to-vendor.module').then(module => module.PayToVendorModule)
  },
  {
    path: 'Vendor-Part-Payment',
    data: RoleObject,
    loadChildren: () => import('./VendorPay/part-payment/part-payment.module').then(module => module.PartPaymentModule)
  },
  {
    path: 'Pay-To-Vendor-Report',
    data: RoleObject,
    loadChildren: () => import('./VendorPay/report/report.module').then(module => module.ReportModule)
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AccountantRoutingModule { }
