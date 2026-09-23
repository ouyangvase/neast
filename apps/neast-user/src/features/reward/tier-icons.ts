import bronze from '../../../assets/images/reward/bronze-tier.png';
// NOTE: asset filename keeps the Flutter app's `sliver` typo.
import silver from '../../../assets/images/reward/sliver-tier.png';
import gold from '../../../assets/images/reward/gold-tier.png';
import platinum from '../../../assets/images/reward/platinum-tier.png';
import diamond from '../../../assets/images/reward/diamond-tier.png';
import fallback from '../../../assets/images/reward/gold-icon.png';

/** reward_tier_constants.dart parity: tier icons by id (1–5). */
export function tierIcon(id: number): number {
  switch (id) {
    case 1:
      return bronze;
    case 2:
      return silver;
    case 3:
      return gold;
    case 4:
      return platinum;
    case 5:
      return diamond;
    default:
      return fallback;
  }
}
