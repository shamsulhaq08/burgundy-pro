import React, { FC, useState, useMemo } from 'react';

export interface ThemeProps {
  themeName: 'Burgundy Pro' | 'Burgundy Soft';
  accentColor?: string;
  isActive: boolean;
  onSelect: (selected: string) => void;
}

export const ThemeCard: FC<ThemeProps> = ({
  themeName,
  accentColor = '#702D45',
  isActive,
  onSelect,
}) => {
  const [hovered, setHovered] = useState<boolean>(false);

  const cardStyle = useMemo(() => ({
    backgroundColor: isActive ? '#321923' : '#211319',
    borderColor: hovered ? '#C44D76' : '#432532',
    color: '#E8DCE1',
  }), [isActive, hovered]);

  return (
    <div
      className="theme-card-container transition-all"
      style={cardStyle}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      onClick={() => onSelect(themeName)}
    >
      <header className="theme-card-header">
        <h3 className="title font-bold text-rose">{themeName}</h3>
        <span className="badge" style={{ backgroundColor: accentColor }}>
          {isActive ? 'ACTIVE' : 'READY'}
        </span>
      </header>
      <p className="description text-muted">
        Experience the luxurious wine-red aesthetics designed for developers.
      </p>
    </div>
  );
};
