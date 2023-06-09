defmodule KifuwarabeWcsc33.CLI.Thesis.IsChecked do
  @moduledoc """

  手番の玉が相手の利きに飛び込んでいますか？

  * これは王手であって、詰めかどうかは分からない
  * 自殺手判定に使う

  """

  @doc """

  手番の玉が利きに飛び込んでいるか判定（詰めかどうかは分からない）

  ## Parameters

    * `pos` - ポジション（Position；局面）
    * `rel_turn` - リレーティブ・ターン（Relative Turn；相対手番）。 `:friend`（手番） または `:opponent`（相手番）

  ## 雑談

    論理値型は関数名の末尾に ? を付ける？

  """
  def is_checked?(pos, rel_turn) do
    # * `src_sq` - ソース・スクウェア（SouRCe SQuare：マス番地）
    src_sq =
      if (rel_turn == :friend and pos.turn == :sente) or
           (rel_turn == :opponent and pos.opponent_turn == :sente) do
        pos.location_of_kings[:k1]
      else
        pos.location_of_kings[:k2]
      end

    if KifuwarabeWcsc33.CLI.Config.is_debug_suicide_move_check?() do
      # 盤表示
      IO.puts(
        """
        [is_checked] DEBUG rel_turn:#{rel_turn} pos.turn:#{pos.turn} src_sq:#{src_sq}
        """ <> KifuwarabeWcsc33.CLI.Views.Position.stringify(pos)
      )
    end

    #
    # 利きに飛び込むか？　先手視点で定義しろだぜ
    # ====================================
    #

    # 北隣のマスから利いているか？
    #
    # ＊
    # ∧
    # │
    # 玉
    in_effect_from_north? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> true
        # ルック（Rook；飛車）
        :r -> true
        # ビショップ（Bishop；角）
        :b -> false
        # ゴールド（Gold；金）
        :g -> true
        # シルバー（Silver；銀）
        :s -> true
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> true
        # ポーン（Pawn；歩）
        :p -> true
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> true
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> true
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> true
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> true
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> true
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> true
        # その他
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 北側のマス
    #
    # ＊
    # ∧ Long
    # │
    # │
    # 玉
    in_effect_from_north_2? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> false
        # ルック（Rook；飛車）
        :r -> true
        # ビショップ（Bishop；角）
        :b -> false
        # ゴールド（Gold；金）
        :g -> false
        # シルバー（Silver；銀）
        :s -> false
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> true
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> true
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> false
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> false
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> false
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> false
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> false
        # その他
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 北東隣のマス
    #
    # 　　　＊
    # 　　─┐
    # 　／
    # 玉
    in_effect_from_north_east? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> true
        # ルック（Rook；飛車）
        :r -> false
        # ビショップ（Bishop；角）
        :b -> true
        # ゴールド（Gold；金）
        :g -> true
        # シルバー（Silver；銀）
        :s -> true
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> false
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> true
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> true
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> true
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> true
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> true
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> true
        # その他
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 北東側のマス
    # 　　─┐ Long
    # 　／
    # ／
    in_effect_from_north_east_2? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> false
        # ルック（Rook；飛車）
        :r -> false
        # ビショップ（Bishop；角）
        :b -> true
        # ゴールド（Gold；金）
        :g -> false
        # シルバー（Silver；銀）
        :s -> false
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> false
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> false
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> true
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> false
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> false
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> false
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> false
        # その他
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 東側のマス
    #
    # ──＞
    in_effect_from_east? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> true
        # ルック（Rook；飛車）
        :r -> true
        # ビショップ（Bishop；角）
        :b -> false
        # ゴールド（Gold；金）
        :g -> true
        # シルバー（Silver；銀）
        :s -> false
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> false
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> true
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> true
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> true
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> true
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> true
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> true
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 東側のマス
    #
    # ────＞ Long
    in_effect_from_east_2? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> false
        # ルック（Rook；飛車）
        :r -> true
        # ビショップ（Bishop；角）
        :b -> false
        # ゴールド（Gold；金）
        :g -> false
        # シルバー（Silver；銀）
        :s -> false
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> false
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> true
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> false
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> false
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> false
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> false
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> false
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 南東側のマス
    # ＼
    # 　─┘
    in_effect_from_south_east? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> true
        # ルック（Rook；飛車）
        :r -> false
        # ビショップ（Bishop；角）
        :b -> true
        # ゴールド（Gold；金）
        :g -> false
        # シルバー（Silver；銀）
        :s -> true
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> false
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> true
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> true
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> false
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> false
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> false
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> false
        # その他
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 南東側のマス
    # ＼
    # 　＼
    # 　　─┘ Long
    in_effect_from_south_east_2? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> false
        # ルック（Rook；飛車）
        :r -> false
        # ビショップ（Bishop；角）
        :b -> true
        # ゴールド（Gold；金）
        :g -> false
        # シルバー（Silver；銀）
        :s -> false
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> false
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> false
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> true
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> false
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> false
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> false
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> false
        # その他
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 南側のマス
    # │
    # Ｖ
    in_effect_from_south? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> true
        # ルック（Rook；飛車）
        :r -> true
        # ビショップ（Bishop；角）
        :b -> false
        # ゴールド（Gold；金）
        :g -> true
        # シルバー（Silver；銀）
        :s -> false
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> false
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> true
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> true
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> true
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> true
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> true
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> true
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 南側のマス
    # │
    # │
    # Ｖ Long
    in_effect_from_south_2? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> false
        # ルック（Rook；飛車）
        :r -> true
        # ビショップ（Bishop；角）
        :b -> false
        # ゴールド（Gold；金）
        :g -> false
        # シルバー（Silver；銀）
        :s -> false
        # ナイト（kNight；桂）
        :n -> false
        # ランス（Lance；香）
        :l -> false
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> true
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> false
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> false
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> false
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> false
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> false
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    # 北北東側のマス
    # 　─┐
    # ／
    # │
    in_effect_from_north_north_east? = fn target_pt ->
      case target_pt do
        # キング（King；玉）
        :k -> false
        # ルック（Rook；飛車）
        :r -> false
        # ビショップ（Bishop；角）
        :b -> false
        # ゴールド（Gold；金）
        :g -> false
        # シルバー（Silver；銀）
        :s -> false
        # ナイト（kNight；桂）
        :n -> true
        # ランス（Lance；香）
        :l -> false
        # ポーン（Pawn；歩）
        :p -> false
        # 成り玉なんて無いぜ
        # :pk
        # It's reasonably a プロモーテッド・ルック（Promoted Rook；成飛）. It's actually ドラゴン（Dragon；竜）
        :pr -> false
        # It's reasonably a プロモーテッド・ビショップ（Promoted Bishop；成角）.  It's actually ホース（Horse；馬）. Ponanza calls ペガサス（Pegasus；天馬）
        :pb -> false
        # 裏返った金なんて無いぜ
        # :pg
        # プロモーテッド・シルバー（Promoted Silver；成銀. Or 全 in one letter）
        :ps -> false
        # プロモーテッド・ナイト（Promoted kNight；成桂. Or 圭 in one letter）
        :pn -> false
        # プロモーテッド・ランス（Promoted Lance；成香. Or 杏 in one letter）
        :pl -> false
        # It's reasonably a プロモーテッド・ポーン（Promoted Pawn；成歩）. It's actually と（"To"；と is 金 cursive）
        :pp -> false
        _ -> raise "unexpected target_piece_type:#{target_pt}"
      end
    end

    is_suicide_move =
      cond do
        # 北隣のマス
        #
        # ＊
        # ∧
        # │
        # 玉
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :north_of,
          in_effect_from_north?,
          true,
          in_effect_from_north_2?
        ) ->
          true

        # 北東側のマス
        # 　─┐
        # ／
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :north_east_of,
          in_effect_from_north_east?,
          true,
          in_effect_from_north_east_2?
        ) ->
          true

        # 東側のマス
        #
        # ──＞
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :east_of,
          in_effect_from_east?,
          true,
          in_effect_from_east_2?
        ) ->
          true

        # 南東側のマス
        # ＼
        # 　─┘
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :south_east_of,
          in_effect_from_south_east?,
          true,
          in_effect_from_south_east_2?
        ) ->
          true

        # 南側のマス
        # │
        # Ｖ
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :south_of,
          in_effect_from_south?,
          true,
          in_effect_from_south_2?
        ) ->
          true

        # 南西側のマス
        # 　／
        # └─
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :south_west_of,
          in_effect_from_south_east?,
          true,
          in_effect_from_south_east_2?
        ) ->
          true

        # 西側のマス
        #
        # ＜──
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :west_of,
          in_effect_from_east?,
          true,
          in_effect_from_east_2?
        ) ->
          true

        # 北西側のマス
        # ┌─
        # 　＼
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :north_west_of,
          in_effect_from_north_east?,
          true,
          in_effect_from_north_east_2?
        ) ->
          true

        # 北北東側のマス
        # 　─┐
        # ／
        # │
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :north_north_east_of,
          in_effect_from_north_north_east?,
          false,
          nil
        ) ->
          true

        # 北北西側のマス
        # ┌─
        # 　＼
        # 　　│
        pos
        |> adjacent(
          rel_turn,
          src_sq,
          :north_north_west_of,
          in_effect_from_north_north_east?,
          false,
          nil
        ) ->
          true

        #
        # その他
        true ->
          false
      end

    is_suicide_move
  end

  #
  # 指定の方向のマスを調べていく
  # ========================
  #
  defp adjacent(
         pos,
         rel_turn,
         src_sq,
         direction_of,
         is_effect?,
         must_long_effect_check,
         is_effect_2?
       ) do
    #
    # 対象のマス
    #
    #   * `pos.turn` - 手番
    #   * `src_sq` - 手番の玉のマス番地
    #   * `direction_of` - 向き
    #
    target_sq =
      KifuwarabeWcsc33.CLI.Mappings.ToDestination.from_turn_and_source(
        if rel_turn == :friend do
          pos.turn
        else
          pos.opponent_turn
        end,
        src_sq,
        direction_of
      )

    if KifuwarabeWcsc33.CLI.Config.is_debug_suicide_move_check?() do
      IO.puts(
        "[adjacent] DEBUG rel_turn:#{rel_turn} pos.turn:#{pos.turn} src_sq:#{src_sq} direction_of:#{direction_of} ----> target_sq:#{target_sq}"
      )
    end

    #
    # 自玉が相手の利きに飛び込んでいるか？
    #
    # - ここは（詰めかではなく）王手かを確認する
    #
    is_suicide_move =
      if KifuwarabeWcsc33.CLI.Thesis.Board.is_in_board?(target_sq) do
        #
        # 盤内だ
        # =====
        #
        # 隣の駒
        target_pc = pos.board[target_sq]

        if KifuwarabeWcsc33.CLI.Config.is_debug_suicide_move_check?() do
          IO.puts("[adjacent] DEBUG in-board target_pc:#{target_pc}")
        end

        if target_pc != :sp do
          #
          # 空マスではない
          # ============
          #
          # 先後
          target_turn = KifuwarabeWcsc33.CLI.Mappings.ToTurn.from_piece(target_pc)

          if KifuwarabeWcsc33.CLI.Config.is_debug_suicide_move_check?() do
            IO.puts("[adjacent] DEBUG target_turn:#{target_turn}")
          end

          if (rel_turn == :friend and target_turn == pos.opponent_turn) or
               (rel_turn == :opponent and target_turn == pos.turn) do
            #
            # 相手の駒だ
            # =========
            #

            # 駒種類
            target_pt = KifuwarabeWcsc33.CLI.Mappings.ToPieceType.from_piece(target_pc)

            if KifuwarabeWcsc33.CLI.Config.is_debug_suicide_move_check?() do
              IO.puts("[adjacent] DEBUG target_pt:#{target_pt}")
            end

            # 自玉に利いているか？
            is_effect?.(target_pt)
          else
            # 自駒
            false
          end
        else
          #
          # 空きマスだ
          # ========
          #
          if must_long_effect_check do
            #
            # 長い利きを調べろ
            # ==============
            #
            pos
            |> far_to(
              rel_turn,
              target_sq,
              direction_of,
              is_effect_2?
            )
          else
            # 桂馬に長い利きは無い
            false
          end
        end
      else
        # 盤外なら自殺手にはならない
        false
      end

    if KifuwarabeWcsc33.CLI.Config.is_debug_suicide_move_check?() do
      IO.puts("[adjacent] DEBUG is_suicide_move:#{is_suicide_move}")
    end

    is_suicide_move
  end

  #
  # 長い利きのマス
  # ============
  #
  # ## Parameters
  #
  #   * `rel_turn` - リレーティブ・ターン（Relative Turn；相対手番）。 `:friend`（手番） または `:opponent`（相手番）
  #
  defp far_to(pos, rel_turn, src_sq, direction_of, is_effect_2?) do
    # 対象のマスが（１手指してる想定なので、反対側が手番）
    target_sq =
      KifuwarabeWcsc33.CLI.Mappings.ToDestination.from_turn_and_source(
        if rel_turn == :friend do
          pos.turn
        else
          pos.opponent_turn
        end,
        src_sq,
        direction_of
      )

    # IO.write("[is_suicide_move far_to] target_sq:#{target_sq}")

    # 相手の利きに飛び込むか？
    is_suicide_move =
      if KifuwarabeWcsc33.CLI.Thesis.Board.is_in_board?(target_sq) do
        #
        # 盤内だ
        # =====
        #
        # その駒は
        target_pc = pos.board[target_sq]
        # IO.write(" target_pc:#{target_pc}")

        if target_pc != :sp do
          #
          # 空マスではない
          # ============
          #
          # 先後が
          target_turn = KifuwarabeWcsc33.CLI.Mappings.ToTurn.from_piece(target_pc)
          # IO.write(" target_turn:#{target_turn}")

          if (rel_turn == :friend and target_turn == pos.opponent_turn) or
               (rel_turn == :opponent and target_turn == pos.turn) do
            #
            # 相手の駒だ
            # =========
            #
            # 駒種類は
            target_pt = KifuwarabeWcsc33.CLI.Mappings.ToPieceType.from_piece(target_pc)
            # IO.write(" target_pt:#{target_pt}")

            # 利きに飛び込むか？
            is_effect_2?.(target_pt)
          else
            # 自駒
            false
          end
        else
          # （空きマスなら）長い利き
          pos
          |> far_to(
            rel_turn,
            target_sq,
            direction_of,
            is_effect_2?
          )
        end
      else
        # 盤外なら自殺手にはならない
        false
      end

    # IO.puts(" is_suicide_move:#{is_suicide_move}")

    is_suicide_move
  end
end
