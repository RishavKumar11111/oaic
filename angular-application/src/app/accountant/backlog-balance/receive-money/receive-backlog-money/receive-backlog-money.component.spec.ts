import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { ReceiveBacklogMoneyComponent } from './receive-backlog-money.component';

describe('ReceiveBacklogMoneyComponent', () => {
  let component: ReceiveBacklogMoneyComponent;
  let fixture: ComponentFixture<ReceiveBacklogMoneyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ReceiveBacklogMoneyComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ReceiveBacklogMoneyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
