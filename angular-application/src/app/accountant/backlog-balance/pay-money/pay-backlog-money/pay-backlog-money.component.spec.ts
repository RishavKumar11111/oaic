import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { PayBacklogMoneyComponent } from './pay-backlog-money.component';

describe('PayBacklogMoneyComponent', () => {
  let component: PayBacklogMoneyComponent;
  let fixture: ComponentFixture<PayBacklogMoneyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PayBacklogMoneyComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PayBacklogMoneyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
